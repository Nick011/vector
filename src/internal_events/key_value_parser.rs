use super::InternalEvent;
use metrics::counter;
use string_cache::DefaultAtom as Atom;

#[derive(Debug)]
pub(crate) struct KeyValueEventProcessed;

impl InternalEvent for KeyValueEventProcessed {
    fn emit_metrics(&self) {
        counter!("events_processed", 1,
            "component_kind" => "transform",
            "component_type" => "key_value",
        );
    }
}

#[derive(Debug)]
pub(crate) struct KeyValueParseFailed {
    pub key: Atom,
    pub error: crate::types::Error,
}

impl InternalEvent for KeyValueParseFailed {
    fn emit_logs(&self) {
        warn!(
            message = "Event failed to parse as KeyValue",
            key = %self.key,
            error = %self.error,
            rate_limit_secs = 30
        )
    }

    fn emit_metrics(&self) {
        counter!("processing_error", 1,
            "component_kind" => "transform",
            "component_type" => "key_value_parser",
            "error_type" => "failed_parse",
        );
    }
}

#[derive(Debug)]
pub(crate) struct KeyValueTargetExists<'a> {
    pub target_field: &'a Atom,
}

impl<'a> InternalEvent for KeyValueTargetExists<'a> {
    fn emit_logs(&self) {
        warn!(
            message = "Target field already exists.",
            target_field = %self.target_field,
            rate_limit_secs = 30
        )
    }

    fn emit_metrics(&self) {
        counter!("processing_error", 1,
            "component_kind" => "transform",
            "component_type" => "key_value_parser",
            "error_type" => "target_field_exists",
        );
    }
}

#[derive(Debug)]
pub(crate) struct KeyValueFieldDoesNotExist {
    pub field: Atom,
}

impl InternalEvent for KeyValueFieldDoesNotExist {
    fn emit_logs(&self) {
        warn!(
            message = "Record failed to parse as KeyValue.",
            field = %self.field,
            rate_limit_secs = 30
        )
    }

    fn emit_metrics(&self) {
        counter!("processing_error", 1,
            "component_kind" => "transform",
            "component_type" => "key_value_parser",
            "error_type" => "failed_parse",
        );
    }
}