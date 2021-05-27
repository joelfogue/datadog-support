# variable datadog_api_key {
#     description = "This can also be set via the DATADOG_API_KEY environment variable."
#     default = "[INSERT_APIKEY_HERE]"
# }

# variable datadog_app_key {
#     description = "This can also be set via the DATADOG_APP_KEY environment variable."
#     default = "[INSERT_APPKEY_HERE]"
# }

variable tier1_alert_notification {
    description = "The notification mention for Tier 1 alerts."
    default = "Tier 1 Alert: @pagerduty"
    #default = "Tier 1 Alert: @matthew.pothier@quickpivot.com"
}

variable tier1_alert_resolve_notification {
    description = "The notification resolution mention for Tier 1 alerts."
    default = "@pagerduty-resolve"
    #default = "Resolved: @matthew.pothier@quickpivot.com"
}

variable escalation_message {
    description = "Escalation message to include in the alerts."
    default = "ESCALATED: This message has been re-triggered because the alert has not been resolved in the defined period of time."
}

variable renotify_interval {
    description = "The number of minutes after the last notification before a monitor will re-notify on the current status."
    default = 60
}

variable timeout_h {
    description = "The number of hours of the monitor not reporting data before it will automatically resolve from a triggered state"
    default = 24
}
