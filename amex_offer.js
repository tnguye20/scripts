async function main() {
  const delay = (f, time = 5000) => {
    return new Promise(resolve => {
      setTimeout(() => {
        f();
        resolve();
      }, time);
    })
  }

  const offers = document.querySelectorAll("[data-rowtype=offer]");
  const offer_nodes = [];

  for (entry of offers.values()) {
    if (entry.querySelector("[data-locator-id=merchantOffer]") === null) {
      continue;
    }
    offer_nodes.push(entry);
  }

  for (offer of offer_nodes) {
    const button = offer.querySelector("button");
    if (button !== null && button.innerHTML === "Add to Card") {
      await delay(() => button.click());
    }
  }

  alert("Done Adding Offer");
}

const _ = main();
