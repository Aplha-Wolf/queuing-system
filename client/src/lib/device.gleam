import ui/theme/types

@external(javascript, "./window_ffi.ffi.js", "is_mobile")
fn is_mobile() -> Bool

pub fn detect_device() -> types.Device {
  case is_mobile() {
    True -> types.Mobile
    False -> types.Web
  }
}
