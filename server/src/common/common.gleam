import gleam/dict
import gleam/int

pub type ApiStatus {
  ApiStatOk
  ApiStatusWarn
  ApiStatusErr
}

pub fn api_status_to_int(status: ApiStatus) -> Int {
  case status {
    ApiStatOk -> 0
    ApiStatusWarn -> 1
    ApiStatusErr -> 2
  }
}

pub fn get_limit_from_query(query: List(#(String, String))) -> Int {
  let res =
    dict.from_list(query)
    |> dict.get("limit")
    |> fn(x) {
      case x {
        Ok(limit) ->
          case int.parse(limit) {
            Ok(y) -> y
            Error(_) -> 0
          }
        Error(_) -> 0
      }
    }
  res
}

pub fn get_offset_from_query(query: List(#(String, String))) -> Int {
  let res =
    dict.from_list(query)
    |> dict.get("offset")
    |> fn(x) {
      case x {
        Ok(offset) ->
          case int.parse(offset) {
            Ok(y) -> y
            Error(_) -> 0
          }
        Error(_) -> 0
      }
    }
  res
}

pub fn get_limit_result_from_query(
  query: List(#(String, String)),
) -> Result(Int, Int) {
  let res =
    dict.from_list(query)
    |> dict.get("limit")
    |> fn(x) {
      case x {
        Ok(limit) ->
          case int.parse(limit) {
            Ok(y) -> Ok(y)
            Error(_) -> Error(0)
          }
        Error(_) -> Error(0)
      }
    }
  res
}

pub fn get_offset_result_from_query(
  query: List(#(String, String)),
) -> Result(Int, Int) {
  let res =
    dict.from_list(query)
    |> dict.get("offset")
    |> fn(x) {
      case x {
        Ok(offset) ->
          case int.parse(offset) {
            Ok(y) -> Ok(y)
            Error(_) -> Error(0)
          }
        Error(_) -> Error(0)
      }
    }
  res
}
