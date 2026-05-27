pub type Queue {
  Queue(id: Int, que_label: String)
}

pub fn empty() -> Queue {
  Queue(id: 0, que_label: "")
}
