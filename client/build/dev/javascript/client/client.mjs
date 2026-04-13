import * as $lustre from "../lustre/lustre.mjs";
import * as $app from "./app.mjs";
import { Ok, makeError } from "./gleam.mjs";

const FILEPATH = "src/client.gleam";

export function main() {
  let app = $lustre.application($app.init, $app.update, $app.view);
  let $ = $lustre.start(app, "#app", undefined);
  if (!($ instanceof Ok)) {
    throw makeError(
      "let_assert",
      FILEPATH,
      "client",
      6,
      "main",
      "Pattern match failed, no pattern matched the value.",
      { value: $, start: 107, end: 156, pattern_start: 118, pattern_end: 123 }
    )
  }
  return undefined;
}
