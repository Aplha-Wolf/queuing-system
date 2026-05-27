import envoy
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn load_env_file(path: String) -> Nil {
  case read_env_file(path) {
    Ok(content) -> {
      content
      |> string.split("\n")
      |> list.each(fn(line) {
        case parse_line(line) {
          Ok(#(key, value)) -> {
            envoy.set(key, value)
            io.println("Loaded: " <> key)
          }
          Error(Nil) -> Nil
        }
      })
    }
    Error(_) -> io.println("Warning: Could not load .env file")
  }
}

fn read_env_file(path: String) -> Result(String, Nil) {
  case simplifile.read(from: path) {
    Ok(content) -> Ok(content)
    Error(_) -> Error(Nil)
  }
}

fn parse_line(line: String) -> Result(#(String, String), Nil) {
  let line = string.trim(line)
  case string.is_empty(line), string.starts_with(line, "#") {
    True, _ -> Error(Nil)
    _, True -> Error(Nil)
    _, _ -> {
      case string.split_once(line, "=") {
        Ok(#(key, value)) -> {
          let key = string.trim(key)
          let value = string.trim(value)
          let value = remove_quotes(value)
          Ok(#(key, value))
        }
        Error(Nil) -> Error(Nil)
      }
    }
  }
}

fn remove_quotes(value: String) -> String {
  let has_start = string.starts_with(value, "\"")
  let has_end = string.ends_with(value, "\"")
  case has_start, has_end {
    True, True -> string.drop_end(value, 1) |> string.drop_start(1)
    True, False -> string.drop_start(value, 1)
    False, True -> string.drop_end(value, 1)
    False, False -> value
  }
}
