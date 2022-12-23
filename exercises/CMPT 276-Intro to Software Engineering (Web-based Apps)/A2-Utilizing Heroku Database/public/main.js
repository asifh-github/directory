// pages transitions:
// main page - add
function add_main() {
    window.location.href ="add.html";
};
// main page - view
function view_main(sid) {
    window.location.href =`view/: ${sid}`;
};

// main page setup
function index_setup(count) {
    // no data functionality
    console.log(count);
    var index_head = document.getElementById('data_main');
    console.log(index_head.innerHTML)
    if(count == 0) {
        index_head.innerHTML = '<p class="alert alert-danger" role="alert">No Data Available.</p>'
    }
    // datablock low gpa functionality
    var index_body = document.getElementsByClassName('dataBlock');
    console.log(index_body);
    for(var i=0; i<index_body.length; i++) {
        var body_data = index_body[i].childNodes[1].lastElementChild.innerText;
        body_data = parseFloat(body_data.substring(5))
        console.log(body_data);
        var body_html = index_body[i].childNodes[1].firstElementChild.outerHTML;
        var body_html_text = index_body[i].childNodes[1].firstElementChild.innerHTML;
        console.log(body_html);
        console.log(body_html_text);
        if(body_data < 1){
            index_body[i].childNodes[1].firstElementChild.outerHTML = `<li class="list-group-item list-group-item-danger"> ${body_html_text} </li>`;
        }
        else if(body_data <2) {
            index_body[i].childNodes[1].firstElementChild.outerHTML = `<li class="list-group-item list-group-item-warning"> ${body_html_text} </li>`;
        }
        else if(body_data <3) {
            index_body[i].childNodes[1].firstElementChild.outerHTML = `<li class="list-group-item list-group-item-success"> ${body_html_text} </li>`;
        }
        else if(body_data < 4){
            index_body[i].childNodes[1].firstElementChild.outerHTML = `<li class="list-group-item list-group-item-primary"> ${body_html_text} </li>`;
        }
        else {
            index_body[i].childNodes[1].firstElementChild.outerHTML = `<li class="list-group-item list-group-item-dark"> ${body_html_text} </li>`;
        }
        console.log(body_html);
    }
};

// add page setup and validation
function add_setup() {
    var valid = false;
    addEventListener('change', function(event) {
        var valid = false;
        var sid_ = this.document.getElementById('add_id').value;
        console.log(sid_);
        var name_  = this.document.getElementById('add_name').value;
        console.log(name_);
        var age_  = this.document.getElementById('add_age').value;
        console.log(age_);
        var height_  = this.document.getElementById('add_height').value;
        console.log(height_);
        var mass_  = this.document.getElementById('add_mass').value;
        console.log(mass_);
        var hcc_  = this.document.getElementById('add_hcc').value;
        console.log(hcc_);
        var gpa_  = this.document.getElementById('add_gpa').value;
        console.log(gpa_);
        //check required inputs
        if(/^[0-9]+$/.test(sid_)) { 
            this.document.getElementById('add_id').style.background = 'none';
            if(/^[a-zA-Z ]+$/.test(name_)) {
                this.document.getElementById('add_name').style.background = 'none';
                if(age_){
                    if(parseInt(age_) > 0 & parseInt(age_) < 100) {
                        this.document.getElementById('add_age').style.background = 'none';
                        if(gpa_) {
                            if(parseFloat(gpa_) >= 0 & parseFloat(gpa_) <= 4.33) {
                                this.document.getElementById('add_gpa').style.background = 'none';
                                valid = true;
                            }
                            else {
                                this.document.getElementById('add_gpa').style.background = 'lightgrey';
                            }
                        }
                        else {
                            this.document.getElementById('add_gpa').style.background = 'lightgrey';
                        }
                    }
                    else {
                        this.document.getElementById('add_age').style.background = 'lightgrey';
                    }
                }
                else {
                    this.document.getElementById('add_age').style.background = 'lightgrey';
                }
            }
            else{
                this.document.getElementById('add_name').style.background = 'lightgrey';
            }
        }
        else{
            this.document.getElementById('add_id').style.background = 'lightgrey';
        }
        console.log(valid);
        if(valid) {
            document.getElementById('add_btn').removeAttribute('disabled');
        }
        else{
            document.getElementById('add_btn').setAttribute('disabled', 'disabled');
        }
    });
};
/*
// view page setup and validation
function view_setup() {
    addEventListener('change', function(event) {
        var valid = false;
        var name_  = this.document.getElementById('view_name').value;
        console.log(name_);
        var age_  = this.document.getElementById('view_age').value;
        console.log(age_);
        var height_  = this.document.getElementById('view_height').value;
        console.log(height_);
        var mass_  = this.document.getElementById('view_mass').value;
        console.log(mass_);
        var hcc_  = this.document.getElementById('view_hcc').value;
        console.log(hcc_);
        var gpa_  = this.document.getElementById('view_gpa').value;
        console.log(gpa_);
        //check required inputs
        if(/^[a-zA-Z]+$/.test(name_)) {
            this.document.getElementById('view_name').style.background = 'none';
            if(age_){
                if(parseInt(age_) > 0 & parseInt(age_) < 100) {
                    this.document.getElementById('view_age').style.background = 'none';
                    if(gpa_) {
                        if(parseFloat(gpa_) >= 0 & parseFloat(gpa_) <= 4.33) {
                            this.document.getElementById('view_gpa').style.background = 'none';
                            valid = true;
                        }
                        else{
                            this.document.getElementById('view_gpa').style.background = 'lightpink';
                        }
                    }
                    else {
                        this.document.getElementById('view_gpa').style.background = 'lightpink';
                    }
                }
                else {
                    this.document.getElementById('view_age').style.background = 'lightpink';
                }
            }
            else {
                this.document.getElementById('view_age').style.background = 'lightpink';
            }
        }
        else {
            this.document.getElementById('view_name').style.background = 'lightpink';
        }
        console.log(valid);
        if(valid) {
            document.getElementById('update').removeAttribute('disabled');
        }
        else{
            document.getElementById('update').setAttribute('disabled', 'disabled');
        }
    });
};
*/
