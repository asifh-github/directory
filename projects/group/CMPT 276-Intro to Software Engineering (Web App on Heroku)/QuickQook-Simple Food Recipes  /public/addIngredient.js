var numIng = 0;
var ingList = [];
function add_ingd() {
  var formEl = document.getElementById("ingd1").value;
  var searchEls = document.getElementById("searchIngredients");
  var apiEls = document.getElementById("apiList");
  if(formEl != "") {
    numIng++;
    if(numIng == 1) {
      searchEls.innerHTML += " " + formEl;
      apiEls.value += formEl;
      
    }
    else {
      searchEls.innerHTML += ", " + formEl;
      apiEls.value += ",+" + formEl;
    }
    ingList.push(formEl);
  }
  else {
    alert("Please include an ingredient");
  }
    
}

function clearIngd() {
  var searchEls = document.getElementById("searchIngredients");
  var apiEls = document.getElementById("apiList");
  searchEls.innerHTML = "Searching for recipes with:";
  apiEls.value = "";
  numIng = 0;
  return true;
}

function checkMin() {
  if(numIng < 3) {
    alert("Please search with at least 3 ingredients");
    return false;
  }
  else {
    return true;
  }
  
}
var input = document.getElementById("ingd1");

//prevent form submission on enter
$(document).on("keydown", ":input:not(textarea)", function(event) {
  return event.key != "Enter";
});


document.getElementById("ingd1").addEventListener("keyup", function(event) {
    
  if (event.key === "Enter") {
    event.preventDefault();
    document.getElementById("addIngd_btn").click();
    document.getElementById("ingd1").value = "";
  }

});


