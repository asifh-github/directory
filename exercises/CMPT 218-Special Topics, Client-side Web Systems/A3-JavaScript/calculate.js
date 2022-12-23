var names = new Array();
var marks = new Array();
var bounds = new Array();
var grades = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

function init(){
    document.getElementById('fileInput').   
        addEventListener('change', handleFileSelect, false);
    var lb = document.getElementsByClassName("white");
    for(i=0; i<lb.length; i++){
        lb[i].addEventListener('change', histogram);
    } 
}
function handleFileSelect(event){
    const reader = new FileReader();
    reader.onload = handleFileLoad;
    reader.readAsText(event.target.files[0]);
}
function handleFileLoad(event){
    var textContent_ = event.target.result;
    console.log(textContent_);
    textContent_ = textContent_.split('\n');
    for(i=1; i<textContent_.length; i++){
        console.log(textContent_[i]);
        var arr = textContent_[i].split(',')
        names.push(arr[0]);
        marks.push(arr[1]);
    }
    console.log(names);
    console.log(marks);
    histogram();
    highest();
    lowest();
    mean();
    median();
}

function histogram(){
    bounds = [];
    var b = document.getElementsByClassName("white");
    for(j=0; j<b.length; j++){
        bounds.push(b[j].value);
    }
    console.log(bounds);

    helper();
    var x = "O";
    var a1 = document.getElementById("a+");
    var a2 = document.getElementById("a");
    var a3 = document.getElementById("a-");
    var b1 = document.getElementById("b+");
    var b2 = document.getElementById("b");
    var b3 = document.getElementById("b-");
    var c1 = document.getElementById("c+");
    var c2 = document.getElementById("c");
    var c3 = document.getElementById("c-");
    var d = document.getElementById("d");
    var f = document.getElementById("f");
    console.log(a1);
    console.log(a2);
    console.log(a3);
    console.log(b1);
    console.log(b2);
    console.log(b3);
    console.log(c1);
    console.log(c2);
    console.log(c3);
    console.log(d);
    console.log(f);
    a1.innerHTML = x.repeat(grades[0]);
    a2.innerHTML = x.repeat(grades[1]);
    a3.innerHTML = x.repeat(grades[2]);
    b1.innerHTML = x.repeat(grades[3]);
    b2.innerHTML = x.repeat(grades[4]);
    b3.innerHTML = x.repeat(grades[5]);
    c1.innerHTML = x.repeat(grades[6]);
    c2.innerHTML = x.repeat(grades[7]);
    c3.innerHTML = x.repeat(grades[8]);
    d.innerHTML = x.repeat(grades[9]);
    f.innerHTML = x.repeat(grades[10]);
}
function helper(){
    grades = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    for(i=0; i<marks.length; i++){
        var x = parseFloat(marks[i]);
        if(x >= bounds[1] && x <= bounds[0]){
            grades[0]++;
        }
        else if(x >= bounds[2]){
            grades[1]++;
        }
        else if(x >= bounds[3]){
            grades[2]++;
        }
        else if(x >= bounds[4]){
            grades[3]++;
        }
        else if(x >= bounds[5]){
            grades[4]++;
        }
        else if(x >= bounds[6]){
            grades[5]++;
        }
        else if(x >= bounds[7]){
            grades[6]++;
        }
        else if(x >= bounds[8]){
            grades[7]++;
        }
        else if(x >= bounds[9]){
            grades[8]++;
        }
        else if(x >= bounds[10]){
            grades[9]++;
        }
        else{
            grades[10]++;
        }
    }
    console.log(grades);
}
function highest(){
    var max = parseFloat(bounds[11]);
    var index_max = null;
    for(i=0; i<marks.length; i++){
        if(marks[i] > max){
            max = parseFloat(marks[i]);
            index_max = i;
        }
    }
    console.log(index_max);
    var h = document.getElementById("max");
    console.log(h);
    h.innerHTML = names[index_max];
}
function lowest(){
    var min = parseFloat(bounds[0]);
    var index_min = null;
    for(i=0; i<marks.length; i++){
        if(marks[i] < min){
            min = parseFloat(marks[i]);
            index_min = i;
        }
    }
    console.log(index_min);
    var l = document.getElementById("min");
    console.log(l);
    l.innerHTML = names[index_min];
}
function mean(){
    var total = 0.0;
    for(i=0; i<marks.length; i++){
        total += parseFloat(marks[i]);
    }
    console.log(total);
    var avg = (total/marks.length).toFixed(2);
    console.log(avg);
    var m = document.getElementById("avg");
    console.log(m);
    m.innerHTML = avg;
}
function median(){
    var arr_copy = Array.from(marks);
    function asc(a, b) { return a-b;}
    arr_copy.sort(asc);
    if(arr_copy.length%2 == 0){
        var index_mid = arr_copy.length/2;
        var m = (parseFloat(arr_copy[index_mid]) + parseFloat(arr_copy[index_mid+1])) / 2;
    }
    else{
        var index_mid = parseInt(arr_copy.length/2);
        var m = arr_copy[index_mid];
    }
    console.log(index_mid);
    var c = document.getElementById("mid");
    console.log(c);
    c.innerHTML = m;
}

