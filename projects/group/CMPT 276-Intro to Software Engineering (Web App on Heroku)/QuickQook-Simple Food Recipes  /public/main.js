// USER SIGNUP PAGE
function user_signup() {
    var valid = false;
    addEventListener('change', function(event) {
        valid = false;
        // get input fields value
        var _fname = this.document.getElementById('fname').value;
        console.log(_fname);
        var _lname = this.document.getElementById('lname').value;
        console.log(_lname);
        var _bday = this.document.getElementById('bday').value;
        console.log(_bday);
        var _gender = this.document.getElementById('gender').value;
        console.log(_gender);
        var _occ = this.document.getElementById('occ').value;
        console.log(_occ);
        var _email = this.document.getElementById('email').value;
        console.log(_email);
        var _pass = this.document.getElementById('pass').value;
        console.log(_pass);
        var _repass = this.document.getElementById('repass').value;
        console.log(_repass);
        // check valid requirements for inputs
        // IMPLEMENT: SHOW ERR_MSG
        if(/^[a-zA-Z\s]+$/.test(_fname)) {
            this.document.getElementById('fname').style.background = 'none';
            if(/^[a-zA-Z]+$/.test(_lname)) {
                this.document.getElementById('lname').style.background = 'none';
                if(/^[0-9\-]+$/.test(_bday)) {
                    this.document.getElementById('bday').style.background = 'none';
                    if(parseInt(_gender) !== 0) {
                        this.document.getElementById('gender').style.background = 'none';
                        if(/^[a-zA-Z]+$/.test(_occ)) {
                            this.document.getElementById('occ').style.background = 'none';
                            if(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(_email)) {
                                this.document.getElementById('email').style.background = 'none';
                                if(_pass.length >= 6) {
                                    this.document.getElementById('pass').style.background = 'none';
                                    if(_pass === _repass) {
                                        this.document.getElementById('repass').style.background = 'none';
                                        valid = true;
                                    }
                                    else {
                                        this.document.getElementById('repass').style.background = 'lightpink';
                                    }
                                }
                                else {
                                    this.document.getElementById('pass').style.background = 'lightgrey';
                                }
                            }
                            else {
                                this.document.getElementById('email').style.background = 'lightgrey';
                            }
                        }
                        else {
                            this.document.getElementById('occ').style.background = 'lightgrey';
                        }
                    }
                    else {
                        this.document.getElementById('gender').style.background = 'lightgrey';
                    }
                }
                else {
                    this.document.getElementById('bday').style.background = 'lightgrey';
                }
            }
            else {
                this.document.getElementById('lname').style.background = 'lightgrey';
            }
        }
        else {
            this.document.getElementById('fname').style.background = 'lightgrey';
        }
        //
        if(valid) {
            document.getElementById('signup').removeAttribute('disabled');
        }
        else{
            document.getElementById('signup').setAttribute('disabled', 'disabled');
        }
    });
}

// USER LOGIN PAGE
function user_login() {
    var valid = false;
    addEventListener('change', function(event) {
        valid = false;
        // get input fields value
        var _email = this.document.getElementById('uid').value;
        //console.log(_email);
        var _pass = this.document.getElementById('upass').value;
        //console.log(_pass);
        // check valid requirements for inputs: empty
        if(_email) {
            this.document.getElementById('uid').style.background = 'none';
            if(_pass){
                this.document.getElementById('upass').style.background = 'none';
                valid = true;
            }
            else {
                this.document.getElementById('upass').style.background = 'lightpink';
            }
        }
        else{
            this.document.getElementById('uid').style.background = 'lightpink';
        }
        //
        if(valid) {
            document.getElementById('login').removeAttribute('disabled');
        }
        else{
            document.getElementById('login').setAttribute('disabled', 'disabled');
        }
    });
}

// USER_UPDATE PAGE
function user_upDel() {
    var valid = false;
    addEventListener('change', function(event) {
        valid = false;
        // get input fields value
        var _fname = this.document.getElementById('fname').value;
        console.log(_fname);
        var _lname = this.document.getElementById('lname').value;
        console.log(_lname);
        var _bday = this.document.getElementById('bday').value;
        console.log(_bday);
        var _gender = this.document.getElementById('gender').value;
        console.log(_gender);
        var _occ = this.document.getElementById('occ').value;
        console.log(_occ);
        var _pass = this.document.getElementById('pass').value;
        console.log(_pass);
        var _repass = this.document.getElementById('repass').value;
        console.log(_repass);
        // check valid requirements for inputs
        // IMPLEMENT: SHOW ERR_MSG
        if(/^[a-zA-Z\s]+$/.test(_fname)) {
            this.document.getElementById('fname').style.background = 'none';
            if(/^[a-zA-Z]+$/.test(_lname)) {
                this.document.getElementById('lname').style.background = 'none';
                if(/^[0-9\-]+$/.test(_bday)) {
                    this.document.getElementById('bday').style.background = 'none';
                    if(parseInt(_gender) !== 0) {
                        this.document.getElementById('gender').style.background = 'none';
                        if(/^[a-zA-Z]+$/.test(_occ)) {
                            this.document.getElementById('occ').style.background = 'none';
                            if(_pass.length >= 6) {
                                this.document.getElementById('pass').style.background = 'none';
                                if(_pass === _repass) {
                                    this.document.getElementById('repass').style.background = 'none';
                                    valid = true;
                                }
                                else {
                                    this.document.getElementById('repass').style.background = 'lightpink';
                                }
                            }
                            else {
                                this.document.getElementById('pass').style.background = 'lightgrey';
                            }
                        }
                        else {
                            this.document.getElementById('occ').style.background = 'lightgrey';
                        }
                    }
                    else {
                        this.document.getElementById('gender').style.background = 'lightgrey';
                    }
                }
                else {
                    this.document.getElementById('bday').style.background = 'lightgrey';
                }
            }
            else {
                this.document.getElementById('lname').style.background = 'lightgrey';
            }
        }
        else {
            this.document.getElementById('fname').style.background = 'lightgrey';
        }
        //
        if(valid) {
            document.getElementById('update').removeAttribute('disabled');
        }
        else{
            document.getElementById('update').setAttribute('disabled', 'disabled');
        }
    });
}

// ADD_RECIPE PAGE
function add_recipe() {
    // setup ingredient flieds
    var ingdDiv = document.getElementById('add_ringd');
    console.log(ingdDiv);
    var _ringd = this.document.getElementById('recipeIngd').value;
    console.log(_ringd);
    for(var i=1; i<=_ringd; i++) {
        ingdDiv.innerHTML += `<div class="form-row col-md-7"><label for="ingd${i}">Ingredient ${i}</label><input type="text" class="form-control" id="ingd${i}" name="f_ingd${i}" placeholder="Include Name" value=""></div>`;
    }
    var valid = false;
    // listen to change
    addEventListener('change', function(event) {
        console.log(event.target.id);
        valid = false;
        // reset ingredient flieds
        if(event.target.id == 'recipeIngd') {
            _ringd = this.document.getElementById('recipeIngd').value;
            console.log(_ringd);
            ingdDiv.innerHTML = "";
            for(var i=1; i<=_ringd; i++) {
                ingdDiv.innerHTML += `<div class="form-row col-md-7"><label for="ingd${i}">Ingredient ${i}</label><input type="text" class="form-control" id="ingd${i}" name="f_ingd${i}" placeholder="Include Name" value=""></div>`;
                if(i === 10) {
                    ingdDiv.innerHTML += `<div class="form-row col-md-7"><button id="addRingd_btn" type="button" class="form-control container btn btn-link" style="width: 200px;margin-top: 10px; margin-bottom: 15px;" onclick="" disabled="disabled">Add Ingredient</button></div>`;
                }
            }
        }
        console.log(ingdDiv);
        console.log(ingdDiv.childNodes[0].childNodes[1].value);
        // get input fileds value
        var _rname = this.document.getElementById('recipeName').value;
        console.log(_rname);
        var _rtime = this.document.getElementById('recipeTime').value;
        console.log(_rtime);
        var _rinfo = this.document.getElementById('recipeInfo').value;
        console.log(_rinfo);
        // check valid requirements for inputs
        if(/^[a-zA-Z\s\-]+$/.test(_rname)) {
            this.document.getElementById('recipeName').style.background = 'none';
            if(parseInt(_rtime) !== 0) {
                this.document.getElementById('recipeTime').style.background = 'none';
                console.log(ingdDiv.childNodes.length);
                for(var i=0; i<ingdDiv.childNodes.length; i++) {
                    var _temp = ingdDiv.childNodes[i].childNodes[1];
                    console.log("printing value of input " + _temp.value);
                    if(/^[0-9a-zA-Z\s\-\+_=,\.()]+$/.test(_temp.value)) {
                        _temp.setAttribute('style', 'background:none');
                        if(i === (ingdDiv.childNodes.length-1)) {
                            console.log("reached last test");
                            if(/^[0-9a-zA-Z\s\n\-\+_=,\.()\[\]]{50,10000}$/.test(_rinfo)) {
                                this.document.getElementById('recipeInfo').style.background = 'none';
                                valid = true;
                                console.log(valid);
                            }
                            else{
                                this.document.getElementById('recipeInfo').style.background = 'lightgrey';
                                console.log(valid);
                            }
                        }
                    }
                    else {
                        _temp.setAttribute('style', 'background:lightgrey');
                    }
                }
            }
            else{
                this.document.getElementById('recipeTime').style.background = 'lightgrey';
            }
        }
        else{
            this.document.getElementById('recipeName').style.background = 'lightgrey';
        }
        if(valid) {
            document.getElementById('postRecipe').removeAttribute('disabled');
        }
        else{
            document.getElementById('postRecipe').setAttribute('disabled', 'disabled');
        }
    });
}

// USER POSTS PAGE
function user_posts(length) {
    console.log(length);
    // 7 == no posts by user
    // no posts functionality
    var index_head = document.getElementById('post_fullPage');
    console.log(index_head.innerHTML)
    if(length === 7) {
        index_head.innerHTML = '<p class="alert alert-primary" role="alert">No Posts Available.</p>'
    }
    var ctimeArr = ['NA', 'Less Than 10 mins', '10-15 mins', '15-20 mins', '20-25 mins', '25-30 mins', '30-35 mins', '35-40 mins', '40-45 mins', '45-50 mins', '50-55 mins', '55-60 mins', '60+ mins'];
    console.log(ctimeArr);
    var ctime = document.getElementsByClassName('card-subtitle');
    console.log(ctime);
    for(var i=0; i<ctime.length; i++) {
        var index = parseInt(ctime[i].innerHTML);
        console.log(index);
        ctime[i].innerHTML = `Cook Time: ` + ctimeArr[index];
    }
}

// USER LIKED PAGE
function user_liked(length) {
    console.log(length);
    // 0 == no posts by user
    // no posts functionality
    var index_head = document.getElementById('post_fullPage');
    console.log(index_head.innerHTML)
    if(length === 0) {
        index_head.innerHTML = '<p class="alert alert-primary" role="alert">No Liked Posts.</p>'
    }
}
