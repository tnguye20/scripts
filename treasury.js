Array.from(document.querySelectorAll("td"))
  .filter(e => e.innerText === "Reportable Proceeds:")
  .map(e => {
    return Array.from(e.parentElement.childNodes).filter(e => e.innerText !== "Reportable Proceeds:")[0].innerHTML.substring(1).replaceAll(",", "");
  })
  .map((n) => Number(n))
  .reduce((acc, n) => acc + n, 0);
