import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor.{
  type Next, type StartResult, continue, new, on_message, start as actor_start,
}

pub type Event {
  QueueCreated
}

pub type NotificationMsg {
  Register(subscriber: Subject(Event))
  Unregister(subscriber: Subject(Event))
  Broadcast(event: Event)
}

type State {
  State(subscribers: List(Subject(Event)))
}

pub type NotificationBus =
  Subject(NotificationMsg)

pub fn start() -> StartResult(Subject(NotificationMsg)) {
  new(State(subscribers: []))
  |> on_message(handle_message)
  |> actor_start
}

fn handle_message(
  state: State,
  msg: NotificationMsg,
) -> Next(State, NotificationMsg) {
  case msg {
    Register(sub) -> continue(State(subscribers: [sub, ..state.subscribers]))
    Unregister(sub) ->
      continue(
        State(subscribers: list.filter(state.subscribers, fn(s) { s != sub })),
      )
    Broadcast(event) -> {
      list.each(state.subscribers, fn(s) { process.send(s, event) })
      continue(state)
    }
  }
}
