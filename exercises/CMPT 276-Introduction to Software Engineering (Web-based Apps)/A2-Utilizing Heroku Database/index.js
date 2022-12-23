const express = require('express')
const path = require('path')
const PORT = process.env.PORT || 3000

// database connection
const { Pool } = require('pg');
var pool;
pool = new Pool({
    connectionString:process.env.DATABASE_URL, 
    ssl: {
        rejectUnauthorized: false
      }
});

console.log(process.env.DATABASE_URL);

var app = express();
app.use(express.json());
app.use(express.urlencoded({extended:false}));
app.use(express.static(path.join(__dirname, 'public')));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// main page 
// get data from DB and render data on pages/index.ejs
app.get('/', (req, res) => {
  var getStudentsQuery = 'select * from student;'; 
  pool.query(getStudentsQuery, (error, result) => {
      if(error) {
          res.end(error);
      }
      else {
          var results = {'students': result.rows};
          console.log(results);
          res.render('pages/index', results);
      }
  });
  //res.render('pages/index');
});

// add_student page 
// post fields to DB or cancel
// and redirect bact to root (/)
app.post('/addStudent', (req, res) => {
  if(req.body.f_cancel != undefined) {
    res.redirect('/');
  }
  else {
    // get fields value
    // check for not required empty fields and set null

    //unique sid check
    function check_sid() {
      return new Promise((resolve, reject) => {
        var getSidQuery = 'select sid from student;'; 
        pool.query(getSidQuery, (error, result) => {
          if(error) {
              res.end(error);
          }
          else {
            var results = result.rows;
            console.log(results);
            var _sid = req.body.f_id;
            console.log(_sid)
            for(var i=0; i<results.length; i++) {
              console.log(results[i]);
              if(parseInt(results[i].sid) === parseInt(_sid)) {
                //console.log('FOUND!!')
                resolve(true);
              }
            }
            resolve(false);
          }
        });
      });
    }
    async function add_new(){
      var found = await check_sid();
      if(found === true) {
        res.redirect('/');
      }
      else {
        var _sid = req.body.f_id;
        console.log(_sid)
        var _name = req.body.f_name;
        console.log(_name);
        var _age = req.body.f_age;
        console.log(_age);
        var _height = req.body.f_height;
        if(!_height) {
            _height = -1;
        }
        console.log(_height);
        var _mass = req.body.f_mass;
        if(!_mass) {
            _mass = -1;
        }
        console.log(_mass);
        var _hcc = req.body.f_hcc;
        console.log(_hcc)
        if(!_hcc) {
            _hcc = 'none';
        }
        var _gpa = req.body.f_gpa;    
        console.log(_gpa);
        // create query 
        var insertStudentQuery = 
        `insert into student(sid, name, age, height, mass, haircolor, gpa) values('${_sid}', '${_name}', ${_age}, ${_height}, ${_mass}, '${_hcc}', ${_gpa});`;
        console.log(insertStudentQuery);
        // insert into database
        pool.query(insertStudentQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            res.redirect('/');
        });
      }  
    }
    add_new();
  }
});

// view_student page 
app.get('/view/:id', (req, res) => {
  var key = (req.params.id).substring(2);
  console.log(key);
  var getStudentViewQuery = `select * from student where sid='${key}';`;
  console.log(getStudentViewQuery);
  pool.query(getStudentViewQuery, (error, result) => {
      if(error) {
          res.end(error);
      }
      else {
          var result = {'studentInfo': result.rows[0]};
          console.log(result)
          res.render('pages/view', result)
      }
  });
  //res.send('ok');
});

// view_student page functionality 
// goback-delete-update
app.post('/uprmStudent', (req, res) => {
  if(req.body.u_back != undefined) {
      res.redirect('/');
  }

  if(req.body.u_delete != undefined) {
      var _sid = req.body.u_id;
      console.log(_sid);
      var deleteStudentQuery = `delete from student where sid='${_sid}';`;
      console.log(deleteStudentQuery);
      pool.query(deleteStudentQuery, (error, result) => {
          if(error) {
              res.end(error);
          }
          else {
              res.redirect('/');
          }
      });
  }

  // check for not required empty fields and set null
  if(req.body.u_update != undefined) {
      var _sid = req.body.u_id;
      console.log(_sid);
      var _name = req.body.u_name;
      console.log(_name);
      var _age = req.body.u_age;
      console.log(_age);
      var _height = req.body.u_height;
      if(!_height) {
          _height = -1;
      }
      console.log(_height);
      var _mass = req.body.u_mass;
      if(!_mass) {
          _mass = -1;
      }
      console.log(_mass);
      var _hcc = req.body.u_hcc;
              if(!_hcc) {
          _hcc = 'none';
      }
      console.log(_hcc)
      var _gpa = req.body.u_gpa;    
      console.log(_gpa);
      var updateStudentQuery = 
      `update student set name='${_name}', age=${_age}, height=${_height}, mass=${_mass}, haircolor='${_hcc}', gpa=${_gpa} where sid='${_sid}';`;
      console.log(updateStudentQuery);
      pool.query(updateStudentQuery, (error, result) => {
          if(error) {
              res.end(error);
          }
          else {
              res.redirect('/');
          }
      });
  }
});

app.listen(PORT, () => console.log(`Listening on ${ PORT }`))
