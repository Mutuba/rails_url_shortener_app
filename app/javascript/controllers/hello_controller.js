import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Hello Contoller!");
    this.element.textContent = "Hello World!";
  }
}
