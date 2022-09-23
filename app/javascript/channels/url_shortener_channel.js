import consumer from "./consumer";
const batch_element = document.getElementById("batch-id");
const batch_id = batch_element.getAttribute("data-batch-id");

consumer.subscriptions.create(
  { channel: "UrlShortenerChannel", batch_id: batch_id },
  {
    received(data) {
      console.log(data.content, "Mutuba big boss");
      const progressBar = document.getElementById("progress-bar");
      const progressWidth = document.getElementById("progress-width");
      const progressText = document.getElementById("progress-text");
      const progressText1 = document.getElementById("progress-text-percentage");

      progressBar.style.visibility = "visible";
      progressWidth.style.width = `${data.content}%`;
      progressText.innerText = `${data.content}%`;
      progressText1.innerText = `${data.content}%`;
    },
  }
);
