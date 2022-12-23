"use strict";
// creates dejimon tracker && fills array with data from local storage
var dt = new DejimonTracker();
var store = JSON.parse(localStorage.User);
console.log(store);
for (let i in store) {
    for (let j in store[i]) {
        dt.add(store[i][j]);
    }
    console.log(dt);
}
// function for list
function list() {
    document.getElementById("add").addEventListener('click', function () {
        window.location.href = "asn4_add.html";
    });
    var ele = document.getElementById("listAdd");
    for (let i of dt.dejimonArr) {
        console.log(i);
        let t = null;
        if (i.type == 1) {
            t = "Yorkshire";
        }
        else if (i.type == 2) {
            t = "Lean";
        }
        else if (i.type == 3) {
            t = "Potbelly";
        }
        ele.innerHTML += `<tr><td>${i.name}</td><td>${t}</td><td><a id=${i.id} class="btn btn-block btn-link btn-sm" href='#' onclick="more(this.id);">More info</a></td><td><a id=${i.id} class="btn btn-block btn-link btn-sm" href='#' onclick="del(this.id);">Delete</a></td></tr>`;
    }
}
//function for add
function addToList() {
    document.getElementById("cancel").addEventListener('click', function () {
        window.location.href = "asn4_main.html";
    });
    document.getElementById("addNew").addEventListener('click', function () {
        var n = document.getElementById("putName").value;
        var t = parseInt(document.getElementById("putType").value);
        var h = parseInt(document.getElementById("putHeight").value);
        var w = parseInt(document.getElementById("putWeight").value);
        var a = parseInt(document.getElementById("putAbility").value);
        let dij;
        dij = { name: n, type: t, height: h, weight: w, ability: a, overall: (h + w + a) / 3 };
        dt.add(dij);
        localStorage.User = JSON.stringify(dt);
        window.location.href = "asn4_main.html";
    });
}
function more(n) {
    localStorage.id_from_html = JSON.stringify(n);
    console.log("index: " + localStorage.id_from_html);
    window.location.href = "asn4_info.html";
}
function moreInfo() {
    document.getElementById("back").addEventListener('click', function () {
        window.location.href = "asn4_main.html";
    });
    var i = JSON.parse(localStorage.id_from_html);
    var e = dt.info(i);
    console.log(e);
    var n = document.getElementById("getName");
    var t = document.getElementById("getType");
    var h = document.getElementById("getHeight");
    var w = document.getElementById("getWeight");
    var a1 = document.getElementById("getAliblityType");
    var a2 = document.getElementById("getAbility");
    var o = document.getElementById("getOverall");
    n.innerHTML = e.name;
    if (e.type == 1) {
        t.innerHTML = "Yorkshire";
        a1.innerHTML = "Water Ability";
    }
    else if (e.type == 2) {
        t.innerHTML = "Lean";
        a1.innerHTML = "Fire Ability";
    }
    else if (e.type == 3) {
        t.innerHTML = "Potbelly";
        a1.innerHTML = "Electric Ability";
    }
    a2.innerHTML = JSON.stringify(e.ability) + " pts";
    h.innerHTML = JSON.stringify(e.height) + " cm";
    w.innerHTML = JSON.stringify(e.weight) + " lbs";
    o.innerHTML = JSON.stringify(e.overall.toFixed(2));
}
function del(n) {
    localStorage.id_from_html2 = JSON.stringify(n);
    console.log("index: " + localStorage.id_from_html2);
    window.location.href = "asn4_delete.html";
}
function deleteDij() {
    document.getElementById("no").addEventListener('click', function () {
        window.location.href = "asn4_main.html";
    });
    document.getElementById("yes").addEventListener('click', function () {
        var i = JSON.parse(localStorage.id_from_html2);
        dt.remove(i);
        localStorage.User = JSON.stringify(dt);
        window.location.href = "asn4_main.html";
    });
}
