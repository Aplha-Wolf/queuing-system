import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class GroceryItem extends $CustomType {
  constructor(name, quantity) {
    super();
    this.name = name;
    this.quantity = quantity;
  }
}
export const GroceryItem$GroceryItem = (name, quantity) =>
  new GroceryItem(name, quantity);
export const GroceryItem$isGroceryItem = (value) =>
  value instanceof GroceryItem;
export const GroceryItem$GroceryItem$name = (value) => value.name;
export const GroceryItem$GroceryItem$0 = (value) => value.name;
export const GroceryItem$GroceryItem$quantity = (value) => value.quantity;
export const GroceryItem$GroceryItem$1 = (value) => value.quantity;

function grocery_item_decoder() {
  return $decode.field(
    "name",
    $decode.string,
    (name) => {
      return $decode.field(
        "quantity",
        $decode.int,
        (quantity) => {
          return $decode.success(new GroceryItem(name, quantity));
        },
      );
    },
  );
}

export function grocery_list_decoder() {
  return $decode.list(grocery_item_decoder());
}

function grocery_item_to_json(grocery_item) {
  let name;
  let quantity;
  name = grocery_item.name;
  quantity = grocery_item.quantity;
  return $json.object(
    toList([["name", $json.string(name)], ["quantity", $json.int(quantity)]]),
  );
}

export function grocery_list_to_json(items) {
  return $json.array(items, grocery_item_to_json);
}
