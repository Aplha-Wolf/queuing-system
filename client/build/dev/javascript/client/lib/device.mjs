import * as $types from "../ui/theme/types.mjs";
import { is_mobile } from "./window_ffi.ffi.js";

export function detect_device() {
  let $ = is_mobile();
  if ($) {
    return new $types.Mobile();
  } else {
    return new $types.Web();
  }
}
