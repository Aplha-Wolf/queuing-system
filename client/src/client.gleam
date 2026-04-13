import app
import lustre

pub fn main() {
  let app = lustre.application(app.init, app.update, app.view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
