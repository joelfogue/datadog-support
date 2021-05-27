resource "datadog_logs_index" "main" {
    name = "main"
    filter {
        query = "*"
    }
    exclusion_filter {
        name = "Filter out debug logs"
        is_enabled = true
        filter {
            query = "status:debug"
            sample_rate = 1.0
        }
    }
    exclusion_filter {
        name = "Filter out non-critical and non-error Lambda logs in the Dev and QA account"
        is_enabled = true
        filter {
            query = "-status:(critical OR error) source:lambda @aws.awslogs.owner:(546627090205 OR 618999335514)"
            sample_rate = 1.0
        }
    }
}
