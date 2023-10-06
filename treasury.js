Array.from(document.querySelectorAll("table"))
  .map((table) =>
    table
      .querySelectorAll("tr")[6]
      .querySelectorAll("td")[1]
      .innerHTML.substring(1)
  )
  .map((n) => Number(n))
  .reduce((acc, n) => acc + n, 0);
