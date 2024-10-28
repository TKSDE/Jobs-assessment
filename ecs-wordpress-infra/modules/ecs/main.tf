resource "aws_ecs_cluster" "wordpress_cluster" {
  name = "wordpress-ecs-cluster"
}

resource "aws_ecs_task_definition" "wordpress" {
  family = "wordpress-task"
  container_definitions = jsonencode([
    {
      name  = "wordpress"
      image = "wordpress:latest"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = aws_secretsmanager_secret.rds_db.secret_string
        }
      ]
    }
  ])
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
}

resource "aws_ecs_service" "wordpress_service" {
  cluster        = aws_ecs_cluster.wordpress_cluster.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count  = 1
  network_configuration {
    subnets = var.private_subnets
  }
}