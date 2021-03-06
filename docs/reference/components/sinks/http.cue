package metadata

components: sinks: http: {
	title:       "HTTP"
	description: "Batches log events to a generic [HTTP](\(urls.http)) endpoint."

	classes: {
		commonly_used: true
		service_providers: []
		delivery:      "at_least_once"
		development:   "stable"
		egress_method: "batch"
	}

	features: {
		buffer: enabled:      true
		healthcheck: enabled: true
		send: {
			batch: {
				enabled:      true
				common:       true
				max_bytes:    1049000
				max_events:   null
				timeout_secs: 1
			}
			compression: {
				enabled: true
				default: "none"
				algorithms: ["none", "gzip"]
				levels: ["none", "fast", "default", "best", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
			}
			encoding: {
				enabled: true
				codec: {
					enabled: true
					default: null
					enum: ["json", "ndjson", "text"]
				}
			}
			request: {
				enabled:                    true
				in_flight_limit:            10
				rate_limit_duration_secs:   1
				rate_limit_num:             1000
				retry_initial_backoff_secs: 1
				retry_max_duration_secs:    10
				timeout_secs:               30
			}
			tls: {
				enabled:                true
				can_enable:             false
				can_verify_certificate: true
				can_verify_hostname:    true
				enabled_default:        false
			}
			to: {
				name:     "HTTP server"
				thing:    "an \(name)"
				url:      urls.http_server
				versions: null

				interface: {
					socket: {
						direction: "outgoing"
						protocols: ["http"]
						ssl: "optional"
					}
				}
			}
		}
	}

	support: {
		platforms: {
			"aarch64-unknown-linux-gnu":  true
			"aarch64-unknown-linux-musl": true
			"x86_64-apple-darwin":        true
			"x86_64-pc-windows-msv":      true
			"x86_64-unknown-linux-gnu":   true
			"x86_64-unknown-linux-musl":  true
		}

		requirements: []
		warnings: []
		notices: []
	}

	configuration: {
		auth: configuration._http_auth & {_args: {
			password_example: "${HTTP_PASSWORD}"
			username_example: "${HTTP_USERNAME}"
		}}
		headers: {
			common:      false
			description: "Options for custom headers."
			required:    false
			warnings: []
			type: object: {
				examples: [
					{
						"Authorization": "${HTTP_TOKEN}"
						"X-Powered-By":  "Vector"
					},
				]
				options: {}
			}
		}
		uri: {
			description: "The full URI to make HTTP requests to. This should include the protocol and host, but can also include the port, path, and any other valid part of a URI."
			required:    true
			warnings: []
			type: string: {
				examples: ["https://10.22.212.22:9000/endpoint"]
			}
		}
	}

	input: {
		logs:    true
		metrics: null
	}
}
