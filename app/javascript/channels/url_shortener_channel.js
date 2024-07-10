import consumer from "./consumer";

document.addEventListener("DOMContentLoaded", () => {
  const userId = document
    .getElementById("user-id")
    .getAttribute("data-user-id");

  if (!userId) {
    console.error("User ID not found.");
    return;
  }

  const batchElements = document.querySelectorAll("[id^='batch-id-']");
  const subscriptions = [];

  batchElements.forEach((batchElement) => {
    const batchId = batchElement.getAttribute("data-batch-id");
    if (!batchId) {
      console.error("Batch ID not found.");
      return;
    }

    const subscription = consumer.subscriptions.create(
      { channel: "UrlShortenerChannel", user_id: userId, batch_id: batchId },
      {
        received(data) {
          console.log(
            `Received data for user ${userId} and batch ${batchId}:`,
            data
          );

          const progressBar = document.getElementById(
            `progress-bar-${batchId}`
          );
          const progressWidth = document.getElementById(
            `progress-width-${batchId}`
          );
          const progressText = document.getElementById(
            `progress-text-${batchId}`
          );
          const progressPercentage = document.getElementById(
            `progress-text-percentage-${batchId}`
          );
          const progressAlert = document.getElementById(
            `progress-alert-${batchId}`
          );

          if (
            !progressBar ||
            !progressWidth ||
            !progressText ||
            !progressPercentage ||
            !progressAlert
          ) {
            console.error(`Progress elements for batch ${batchId} not found.`);
            return;
          }

          progressBar.style.visibility = "visible";
          progressWidth.style.width = `${data.content}%`;
          progressText.innerText = `${data.content}%`;
          progressPercentage.innerText = `${data.content}%`;

          if (data.content === 100) {
            progressText.innerText = "Upload complete";
            progressPercentage.innerText = "100%";
            progressAlert.innerText = "Upload complete";

            subscription.unsubscribe();
          }
        },
      }
    );

    subscriptions.push(subscription);
  });
});
