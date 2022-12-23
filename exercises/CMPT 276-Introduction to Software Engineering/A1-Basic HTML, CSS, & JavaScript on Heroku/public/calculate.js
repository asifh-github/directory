// letter grades arr
var letterGradesArr = new Array();
var letterGrades = document.getElementById("bounds").getElementsByTagName("td");
for(var k=0; k<letterGrades.length; k=k+2) {
    letterGradesArr.push(letterGrades[k].innerText); 
}
//console.log(temp3);

// create two arrs to store grades & bounds
var gradesArr = [65.95, 56.98, 78.62, 96.1, 90.3, 72.24, 
    92.34, 60.00, 81.43, 86.22, 88.33, 9.03, 49.93, 52.34,
    53.11, 50.10, 88.88, 55.32, 55.69, 61.68, 70.44, 70.54, 
    90.0, 71.11, 80.01];
//console.log(gradesArr);

var boundsArr = new Array();
// get bounds from bounds_html
var bounds = document.getElementById("bounds").getElementsByTagName("input");
for(var j=0; j<bounds.length; j++) {
    boundsArr.push(parseFloat(bounds[j].value));
}
//console.log(boundsArr);

// plot histogram function to histgram_html
function histogram() {
    // arr to store frequency
    var histArr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    for(var i=0; i<gradesArr.length; i++) {
        if(gradesArr[i]<=boundsArr[0] && gradesArr[i]>=boundsArr[1]) {
            histArr[0]++;
        }
        else if(gradesArr[i]<boundsArr[1] && gradesArr[i]>=boundsArr[2]) {
            histArr[1]++;
        }
        else if(gradesArr[i]<boundsArr[2] && gradesArr[i]>=boundsArr[3]) {
            histArr[2]++;
        }
        else if(gradesArr[i]<boundsArr[3] && gradesArr[i]>=boundsArr[4]) {
            histArr[3]++;
        }
        else if(gradesArr[i]<boundsArr[4] && gradesArr[i]>=boundsArr[5]) {
            histArr[4]++;
        }
        else if(gradesArr[i]<boundsArr[5] && gradesArr[i]>=boundsArr[6]) {
            histArr[5]++;
        }
        else if(gradesArr[i]<boundsArr[6] && gradesArr[i]>=boundsArr[7]) {
            histArr[6]++;
        }
        else if(gradesArr[i]<boundsArr[7] && gradesArr[i]>=boundsArr[8]) {
            histArr[7]++;
        } 
        else if(gradesArr[i]<boundsArr[8] && gradesArr[i]>=boundsArr[9]) {
            histArr[8]++;
        }
        else if(gradesArr[i]<boundsArr[9] && gradesArr[i]>=boundsArr[10]) {
            histArr[9]++;
        }
        else {
            histArr[10]++;
        }
    }
    //console.log(histArr);

    var freq = document.getElementsByClassName("histogram");
    for(var j=0; j<histArr.length; j++) {
        // outerHTML: '<td class="histogram">0</td>'
        freq[j].outerHTML = '<td class="histogram" ' + 'style="background-color:coral; width:' + histArr[j]*(25) + 'px;"></td>';
        //("0").repeat(histArr[j]);
    }
}
// function init
histogram();

// change bounds (event listener)
addEventListener('change', function(event) {
    //console.log(event);
    //console.log(event.target);
    if(event.target.getElementsByClassName("bounds")) {
        var count = 0;
        boundsArr = [];
        bounds = document.getElementById("bounds").getElementsByTagName("input");
        // check for max & min
        if(parseFloat(bounds[0].value) === 100 && parseFloat(bounds[bounds.length-1].value) === 0) {
            boundsArr.push(parseFloat(bounds[0].value));
            count++;
            for(var i=1; i<bounds.length; i++) {
                var temp = parseFloat(bounds[i].value);
                // check for invalid input and insert
                if(temp < boundsArr[i-1]) {
                    boundsArr.push(temp);
                    count++;
                    //console.log(boundsArr[i]);
                }
                else {
                    var val = document.getElementById("valid_input");
                    val.innerHTML = "";
                    var err = document.getElementById("invalid_input");
                    //console.log(count);
                    err.innerHTML = letterGradesArr[count-1] + "  & " + letterGradesArr[count] + "  Bounds Do Not Align!";
                }
            }
            if(count === bounds.length) {
                console.log(boundsArr);
                var err = document.getElementById("invalid_input");
                err.innerHTML = "";
                var x = Math.floor((Math.random() * 5) + 1);
                var val = document.getElementById("valid_input");
                val.innerHTML = "Bounds Updated Successfully" + (".").repeat(x);
                histogram();
            }
        }
        else {
            var val = document.getElementById("valid_input");
            val.innerHTML = "";
            var err = document.getElementById("invalid_input");
            err.innerHTML = "Accepted Bounds: Max = 100  &  F/Min = 0";
        }
    }
});

// (event handler)
document.getElementById("grades").querySelector('[type="text"]').onclick = (event) => {
        var out = document.getElementById("valid_input");
        out.innerHTML = "Press Enter to Add Grades.";
        var err = document.getElementById("invalid_input");
        err.innerHTML = "";
    };

// add new grades (event listener)
addEventListener('keypress', function(event) {
    // if the user presses the "Enter" key on the keyboard
    if(event.key === "Enter") {
        var newGrade = document.getElementById("grades").querySelector('[type="text"]');
        console.log(newGrade.value);
        newGrade = parseFloat(newGrade.value);
        max = boundsArr[0];
        min = boundsArr[boundsArr.length - 1];
        // check for invalid input
        if(newGrade<=max && newGrade>=min) {
            gradesArr.push(newGrade);
            console.log(gradesArr);
            var err = document.getElementById("invalid_input");
            err.innerHTML = "";
            var x = Math.floor((Math.random() * 5) + 1);
            var val = document.getElementById("valid_input");
            val.innerHTML = "Grade Added Successfully" + (".").repeat(x);
            histogram();
        }
        else {
            var err = document.getElementById("invalid_input");
            err.innerHTML = "Range of Grades: " + min + " to " + max;
            var val = document.getElementById("valid_input");
            val.innerHTML = "";
        }
    }
  });








