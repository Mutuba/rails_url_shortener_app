import consumer from "./consumer";
consumer.subscriptions.create("UrlShortenerChannel", {
  received(data) {
    const progressBar = document.getElementById("progress-bar");
    const progressWidth = document.getElementById("progress-width");
    const progressText = document.getElementById("progress-text");
    const progressText1 = document.getElementById("progress-text-percentage");

    progressBar.style.visibility = "visible";
    progressWidth.style.width = `${data.content}%`;
    progressText.innerText = `${data.content}%`;
    progressText1.innerText = `${data.content}%`;
  },
});
