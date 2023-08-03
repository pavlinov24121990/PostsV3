import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  
  initialize() {
    var myModal = new bootstrap.Modal(document.getElementById("staticBackdrop"));
    myModal.show();
  };
}
