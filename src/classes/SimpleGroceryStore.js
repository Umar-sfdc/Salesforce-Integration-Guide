// callout using js.

const URL = "https://simple-grocery-store-api.click";

async function fetchData() {
  try {
    const response = await fetch(URL, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
    });

    const data = await response.json();

    console.log("callout successful : ", data);
    console.log("status code : ", response.status);
  } catch (Error) {
    console.log(
      "Callout is failed due to unknown reason here is why? ",
      Error.message,
    );
  }
}

console.log("application is running....");
fetchData();
