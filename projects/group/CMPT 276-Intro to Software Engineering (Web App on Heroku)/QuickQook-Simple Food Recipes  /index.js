// EXPORT PACKAGES
const cors = require('cors');
const express = require('express');
const session = require('express-session');
const { get } = require('http');
const path = require('path');
const multer  = require('multer');
const upload = multer({ dest: 'uploads/' });

const { uploadFile, getFileStream } = require('./s3');

const PORT = process.env.PORT || 5000
// const PORT = 4000

// DB CONNECTION
const { Pool } = require('pg');
const { clearCache } = require('ejs');
var pool;
pool = new Pool({
    connectionString:process.env.DATABASE_URL,
    ssl: {
        rejectUnauthorized: false
      }
});

//Local field testing for Victory DO NOT DELETE JUST COMMENT OUT
// const { Pool } = require('pg');
// var pool;
// pool = new Pool({
//     connectionString: process.env.DATABASE_URL || "postgres://postgres:779977@localhost/qqapp"
// });


// DB Connection for Localhost
// const creds = {

//     host: "localhost",
//     database: "mydb",//     password: "1234",
//     port: 5432,
// };

// const { Pool } = require('pg');
// var pool;
// pool = new Pool(creds);


// EXPRESS APP
var app = express();


// SESSION
app.use(session({
    name: 'session',
    secret: 'zordon',
    resave: false,
    saveUninitialized: false,
    maxAge: 30 * 60 * 1000  // 30 minutes
}))


// APP SETTINGS
app.use('/', cors());
app.use(express.json());
app.use(express.urlencoded({extended:false}));
app.use(express.static(path.join(__dirname, 'public')));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');


// HOME - W/O USER LOGIN
app.get('/', (req, res) => res.render('pages/index'));


// USER SIGNUP
app.post('/userSignup', (req, res) => {
    //unique email check function: promise
    function check_email() {
        return new Promise((resolve, reject) => {
            var _email = req.body.f_email;
            console.log(_email)
            var getEmailQuery = `select * from usersinfonew where email='${_email}';`;
            console.log(getEmailQuery);
            pool.query(getEmailQuery, (error, result) => {
                if(error) {
                    console.log(error);
                    res.send(error);
                }
                else {
                    var results = result.rows;
                    console.log(results.length);
                    if(parseInt(results.length) === 0) {
                        resolve(false);
                    }
                    resolve(true);
                }
            });
        });
    }
    // add new user function: async
    async function add_user() {
        console.log('adding user');
        var found = await check_email();
        if(found === true) {
            // IMPLEMENT: SHOW ERR_MSG
            res.redirect('/exists');
        }
        else {
            // get fields value
            var _fname = req.body.f_fname;
            console.log(_fname);
            var _lname = req.body.f_lname;
            console.log(_lname);
            var _bday = req.body.f_bday;
            console.log(_bday);
            var _gender = req.body.f_gender;
            console.log(_gender);
            var _occ = req.body.f_occ;
            console.log(_occ);
            var _email = req.body.f_email;
            console.log(_email);
            var _pass = req.body.f_pass;
            console.log(_pass);
            // create query
            var insertUserQuery = `insert into usersinfonew(fname, lname, bday, gender, occupation, email, pass, valid) values('${_fname}', '${_lname}', '${_bday}', '${_gender}', '${_occ}', '${_email}', '${_pass}', TRUE);`;
            console.log(insertUserQuery);
            pool.query(insertUserQuery, (error, result) => {
                if(error) {
                    res.end(error);
                }
                user_arr = [];
                user_obj = {'fname':_fname, 'lname':_lname, 'bday':_bday, 'gender':_gender, 'occupation':_occ, 'email':_email, 'pass':_pass};
                user_arr.push(user_obj);
                // IMPLEMENT: SHOW SUCCESS_MSG
                res.redirect('/login.html');
            });
        }
    }
    add_user();
});

app.get('/exists', (req, res) => {
    res.render('pages/emailExistsLandingPage');
})


// USERS LOGIN
app.post('/userLogin', async (req, res) => {
    console.log(req.body);
    var _email = req.body.f_uid;
    console.log(_email);
    var _pass = req.body.f_upass;
    console.log(_pass);
    // ADMIN LOGIN
    if(req.body.f_isadmin === 'on') {
        var isAdminQuery = `select * from admins where email='${_email}' and pin='${_pass}';`;
        console.log(isAdminQuery);
        await pool.query(isAdminQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = result.rows;
            console.log(results);
            if(results.length !== 0) {
                req.session.admin = req.body;
                res.redirect('/admin')
            }
            // IMPLEMENT: ERR_MSG
            else {
                res.redirect('/login.html');
            }
        });
    }
    else {
        // USER LOGIN
        var getUserQuery = `select * from usersinfonew where email='${_email}' and pass='${_pass}';`;
        console.log(getUserQuery);
        await pool.query(getUserQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = result.rows;
            console.log(results);
            if(results.length !== 0) {
                if(results[0].valid !== true) {
                    res.redirect('/blocked');
                }
                else {
                    req.session.user = req.body;
                    res.redirect('/profile')
                }
            }
            // IMPLEMENT: ERR_MSG
            else {
                res.redirect('/login.html');
            }
        });
    }
});

app.get('/blocked', (req, res)=> {
    res.render('pages/blockedLandingPage');
});


// ADMIN HOME
app.get('/admin', async (req, res) => {
    if (req.session.admin) {
        var _uid = req.session.admin.f_uid;
        console.log(_uid);
        // IMPLEMENT: QUERY FOR USER_INFO (distinct table) FOR PROFILE INFO
        var getAllLikesQuery = `select * from likesnew order by time desc;`;
        console.log(getAllLikesQuery);
        await pool.query(getAllLikesQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'likes': result.rows};
            console.log(results);
            for(var i=0; i<results.likes.length; i++) {
                if(results.likes[i].time != null) {
                    results.likes[i].time = (results.likes[i].time).toString().substring(0, 24);
                }
            }
            console.log(results);
            res.render('pages/admin_index', results);
        });
    }
    else {
        res.redirect('/login.html');
    }
});


// ADMIN_USERS PAGE
app.get('/admin_users', async (req, res) => {
    if(req.session.admin) {
        var _uid = req.session.admin.f_uid;
        console.log(_uid);
        var getAllUsersQuery = `select * from usersinfonew;`;
        console.log(getAllUsersQuery);
        await pool.query(getAllUsersQuery, async (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'users': result.rows};
            console.log(results);
            var getPostCountQuery = `select postby, count(*) from posts group by postby;`;
            console.log(getPostCountQuery);
            await pool.query(getPostCountQuery, (error, result) => {
                if(error) {
                    res.end(error);
                }
                var counts =  result.rows;
                console.log(counts);
                for(var i=0; i<results.users.length; i++) {
                    for(var j=0; j<counts.length; j++) {
                        if(results.users[i].email == counts[j].postby) {
                            results.users[i].count = counts[j].count;
                            break;
                        }
                        results.users[i].count = 0;
                    }
                }
                console.log(results);
                res.render('pages/admin_users', results);
            });
        });
    }
    else {
        res.redirect('/login.html');
    }
});


// ADMIN_POSTS PAGE
app.get('/admin_posts', async (req, res) => {
    if(req.session.admin) {
        var _uid = req.session.admin.f_uid;
        console.log(_uid);
        var getAllPostsQuery = `select * from posts;`;
        console.log(getAllPostsQuery);
        await pool.query(getAllPostsQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'posts': result.rows};
            console.log(results);
            res.render('pages/admin_posts', results);
        });
    }
    else {
        res.redirect('/login.html');
    }
});


// USER HOME
app.get('/profile', async (req,res)=>{
    if (req.session.user) {
        var _uid = req.session.user.f_uid;
        console.log(_uid);
        // IMPLEMENT: QUERY FOR USER_INFO (distinct table) FOR PROFILE INFO
        var getUserQuery = `select * from usersinfonew where email='${_uid}';`;
        console.log(getUserQuery);
        await pool.query(getUserQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'user': result.rows[0]};
            console.log(results);
            res.render('pages/user_index', results);
        });
    }
    else {
        res.redirect('/login.html');
    }
});


// USER LOGOUT
app.get('/logout', (req, res) => {
    if(req.session) {
        req.session.destroy();
        res.redirect('/login.html');
        console.log('Logout Ok');
    }
    else {
        res.redirect('/login.html');
    }
});


//SEARCH RECIPE
app.post('/searchRecipe', async (req,res)=> {
    if(req.session.user) {
        var getRecipesQuery = `SELECT * FROM posts`;
        var email = req.session.user.f_uid;
        try {
            var getUserInfoQuery = `select * from usersinfonew where email= '${email}'`;
            const temp1 = await pool.query(getUserInfoQuery);
            //get all recipes, handle in recipeSearch
            try {
                const result = await pool.query(getRecipesQuery);
                console.log(result);
                ingredientsToBeSearched = req.body.apiList;
                const data = {results: result.rows};
                data["fname"] = temp1.rows[0].fname;
                data["lname"] = temp1.rows[0].lname;
                console.log(data);
                res.render('pages/recipeSearchUser.ejs', data);
            }
            catch(e) {
                console.log("recipe error");
                res.send(e);
            }
        }
        catch(e){
            console.log("user error");
            res.send(e);
        }
    }
    else{
        var getRecipesQuery = `SELECT * FROM posts`;
        try {
            //get all recipes, handle in recipeSearch
            const result = await pool.query(getRecipesQuery);
            ingredientsToBeSearched = req.body.apiList;
            const data = {results: result.rows};
            res.render('pages/recipeSearch.ejs', data);
        }
        catch(e){
            res.send(e);
        }
    }
});


//VIEW RECIPE INFO
app.post('/viewRecipe', async(req, res)=> {
    if(req.session.user) {
        var query = `select * from usersinfonew where email='${req.session.user.f_uid}';`;
        const temp1 = await pool.query(query);
        recipeId = req.body.rId;
        recipeImg = req.body.rImg;
        var result = recipeId;
        const data = {results: result};
        data["fname"] = temp1.rows[0].fname;
        data["lname"] = temp1.rows[0].lname;
        res.render('pages/recipeDescriptionUser.ejs', data);

    }
    else {
        recipeId = req.body.rId;
        recipeImg = req.body.rImg;
        var result = recipeId;
        const data = {results: result};
        res.render('pages/recipeDescription.ejs', data);
    }
});


//VIEW RECIPE INFO - USER UPLOADED
app.post('/qqviewRecipe', async (req, res)=> {
    var getRecipeQuery = `select * from posts where postid = '${req.body.rId}'`;
    console.log(req.body.postid);
    try {
        const result = await pool.query(getRecipeQuery);
        const data = {results: result.rows};
        res.render('pages/qqrecipeDescription.ejs', data);
    }
    catch (e) {
        res.send(e);
    }
});


// USER ADD_RECIPE
app.get('/addRecipe', async (req, res) => {
    if(req.session.user) {
        var email = req.session.user.f_uid;
        console.log(email);
        var getUserQuery = `select * from usersinfonew where email='${email}';`;
        console.log(getUserQuery);
        await pool.query(getUserQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'user': result.rows[0]};
            console.log(results);
            res.render('pages/add_recipe', results);
        });
    }
    else {
        res.redirect('/login.html');
    }
});

// USER SEARCH
app.get('/search', async (req, res) => {
    if(req.session.user) {
        var email = req.session.user.f_uid;
        console.log(email);
        var getUserQuery = `select * from usersinfonew where email='${email}';`;
        console.log(getUserQuery);
        await pool.query(getUserQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'user': result.rows[0]};
            console.log(results);
            res.render('pages/search_recipe', results);
        });
    }
    else {
        res.redirect('/');
    }
});


//SENDS USERS POST PICTURE FROM THE S3 SERVER TO THE PAGE
app.get('/images/:key', (req, res) => {
  console.log(req.params);
  const key = req.params.key;
  const readStream = getFileStream(key);

  readStream.pipe(res);
});


app.post('/addRecipePost', upload.single('recipeImage'), async (req, res) => {
    // check for valid session/if session exixts
    if(req.session.user){
        //UPLOAD IMAGE FIELD
        const file = req.file;
        var imgkey = '';
        if(file != undefined) {
        console.log(file);
        console.log(file.filename);
        const uploadResults = await uploadFile(file);
        console.log(uploadResults);
        imgkey = file.filename;
        console.log(imgkey);
        }
        // get fields value
        var email = req.body.f_emailForAdd;
        console.log(email);
        var rname = req.body.f_recipeName;
        console.log(rname);
        var rtime = req.body.f_recipeTime;
        console.log(rtime);
        var ringd = req.body.f_recipeIngd;
        console.log(ringd);
        var rinfo = req.body.f_recipeInfo;
        console.log(rinfo);
        var getCountQuery = `select * from posts;`;
        console.log(getCountQuery);
        await pool.query(getCountQuery, async(error, result) => {
            if(error) {
                res.end(error);
            }
            var count = result.rows.length;
            console.log(count);
            // create unique tag for posts
            var rid = "qq" + (count + 1);
            var tags = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_";
            for(var i=0; i<3; i++) {
                rid += tags.charAt(Math.floor(Math.random() * tags.length));
            }
            console.log(rid);
            // create ingredients list/string
            var ringdlist = "";
            for(var i=1; i<=ringd; i++) {
                var temp = `req.body.f_ingd${i}`;
                ringdlist += eval(temp);
                ringdlist += ':';
            }
            console.log(ringdlist);
            var likes = 0;
            var insertPostQuery = `insert into posts(postid, postby, postname, postctime, postingd, postingdlist, postinfo, postlikes, imgtag, validpost) values('${rid}', '${email}', '${rname}', ${rtime}, ${ringd}, '${ringdlist}', '${rinfo}', ${likes}, '${imgkey}', TRUE);`;
            console.log(insertPostQuery);
            await pool.query(insertPostQuery, (error, result) => {
                if(error) {
                    res.end(error);
                }
                res.redirect('/profile');
            });
        });
    }
    else {
        res.redirect('/login.html');
    }
});


// USER POSTS PAGE
app.get('/posts', async (req, res) => {
    if(req.session.user) {
        var email = req.session.user.f_uid;
        console.log(email);
        var getUserPostsQuery = `select * from posts, usersinfonew where postby=email and postby='${email}';`;
        console.log(getUserPostsQuery);
        await pool.query(getUserPostsQuery, async (error, result) => {
            if(error) {
                res.end(error);
            }
            var qlen = result.rows.length;
            console.log(qlen);
            if(qlen === 0) {
                var getUserQuery = `select * from usersinfonew where email='${email}';`;
                console.log(getUserQuery);
                await pool.query(getUserQuery, (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    var results = {'posts': result.rows};
                    console.log(results);
                    res.render('pages/user_posts', results);
                });
            }
            else{
                var results = {'posts': result.rows};
                console.log(results);
                res.render('pages/user_posts', results);
            }
        });
    }
    else {
        res.redirect('/login.html');
    }
});


// USER_PROFILE UPDATE
app.get('/profile_update', async (req, res) => {
    if(req.session.user) {
        var email = req.session.user.f_uid;
        console.log(email);
        var getUserQuery = `select * from usersinfonew where email='${email}';`;
        console.log(getUserQuery);
        await pool.query(getUserQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'user': result.rows[0]};
            console.log(results);
            res.render('pages/user_update', results);
        });
    }
    else {
        res.redirect('/login.html');
    }
})
//
app.post('/userUpDel', async (req, res) => {
    if(req.session.user) {
        if(req.body.user_back != undefined) {
            res.redirect('/profile')
        }
        else if(req.body.user_delete != undefined) {
            var email = req.body.f_email;
            console.log(email);
            var deleteAccountQuery = `delete from usersinfonew where email='${email}';`;
            console.log(deleteAccountQuery);
            await pool.query(deleteAccountQuery, async (error, result) => {
                if(error) {
                    res.end(error);
                }
                var deletePostsQuery = `delete from posts where postby='${email}';`;
                console.log(deletePostsQuery);
                await pool.query(deletePostsQuery, async (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    var deleteLikesQuery = `delete from likesnew where by='${email}';`;
                    console.log(deleteLikesQuery);
                    await pool.query(deleteLikesQuery, async (error, result) => {
                        if(error) {
                            res.end(error);
                        }
                        else {
                            res.redirect('/');
                        }
                    });
                });
            });
        }
        else if(req.body.user_update != undefined) {
            var email = req.body.f_email;
            console.log(email);
            var _fname = req.body.f_fname;
            console.log(_fname);
            var _lname = req.body.f_lname;
            console.log(_lname);
            var _bday = req.body.f_bday;
            console.log(_bday);
            var _gender = req.body.f_gender;
            console.log(_gender);
            var _occ = req.body.f_occ;
            console.log(_occ);
            var _pass = req.body.f_pass;
            console.log(_pass);
            var updateAccountQuery =
            `update usersinfonew set fname='${_fname}', lname='${_lname}', bday='${_bday}', gender='${_gender}', occupation='${_occ}', pass='${_pass}' where email='${email}';`;
            console.log(updateAccountQuery);
            pool.query(updateAccountQuery, (error, result) => {
                if(error) {
                    res.end(error);
                }
                else {
                    res.redirect('/profile');
                }
            });
        }
    }
    else {
        res.redirect('/login.html');
    }
})


// USER_POST_VIEW PAGE
app.get('/view_post/:id', async (req, res) => {
    if(req.session.user) {
        var _postid = req.params.id.substring(1);
        console.log(_postid);
        var email = req.session.user.f_uid;
        console.log(email);
        getPostQuery = `select * from posts, usersinfonew where postby=email and postid='${_postid}';`;
        console.log(getPostQuery);
        await pool.query(getPostQuery, async (error, result) => {
            if(error) {
                res.send(error);
            }
            var results = {'post': result.rows[0]};
            console.log(results);
            var getUserQuery = `select * from usersinfonew where email='${email}';`;
            console.log(getUserQuery);
            await pool.query(getUserQuery, async (error, result) => {
                if(error) {
                    res.send(error);
                }
                results.post["ufname"] = result.rows[0].fname;
                results.post["ulname"] = result.rows[0].lname;
                results.post["uemail"] = result.rows[0].email;
                console.log(results);
                var getlikeQuery = `select * from likesnew where id='${_postid}' and likedby='${email}';`;
                console.log(getlikeQuery);
                await pool.query(getlikeQuery, (error, result) => {
                    if(error) {
                        res.send(error);
                    }
                    if(result.rows.length === 0) {
                        results.post["id"] = "";
                        results.post["likedby"] = "";
                    }
                    else{
                        results.post["id"] = result.rows[0].id;
                        results.post["likedby"]= result.rows[0].likedby;
                    }
                    console.log(results);
                    res.render('pages/view_post', results);
                });
            });
        });
    }
    else {
        res.redirect('/login.html');
    }
})
//
// USER_POST_VIEW for FAV PAGE
app.get('/view_post_fav/:id', async (req, res) => {
    if(req.session.user) {
        var _postid = req.params.id.substring(1);
        console.log(_postid);
        var email = req.session.user.f_uid;
        console.log(email);
        getPostQuery = `select * from posts, usersinfonew where postby=email and postid='${_postid}';`;
        console.log(getPostQuery);
        await pool.query(getPostQuery, async (error, result) => {
            if(error) {
                res.send(error);
            }
            var results = {'post': result.rows[0]};
            console.log(results);
            var getUserQuery = `select * from usersinfonew where email='${email}';`;
            console.log(getUserQuery);
            await pool.query(getUserQuery, async (error, result) => {
                if(error) {
                    res.send(error);
                }
                results.post["ufname"] = result.rows[0].fname;
                results.post["ulname"] = result.rows[0].lname;
                results.post["uemail"] = result.rows[0].email;
                console.log(results);
                var getlikeQuery = `select * from likesnew where id='${_postid}' and likedby='${email}';`;
                console.log(getlikeQuery);
                await pool.query(getlikeQuery, (error, result) => {
                    if(error) {
                        res.send(error);
                    }
                    if(result.rows.length === 0) {
                        results.post["id"] = "";
                        results.post["likedby"] = "";
                    }
                    else{
                        results.post["id"] = result.rows[0].id;
                        results.post["likedby"]= result.rows[0].likedby;
                    }
                    console.log(results);
                    res.render('pages/view_post_fav', results);
                });
            });
        });
    }
    else {
        res.redirect('/login.html');
    }
})

//USER_POST_VIEW for SEARCH PAGE
app.get('/view_post_search/:id', async (req, res) => {
    if(req.session.user) {
        var _postid = req.params.id.substring(1);
        console.log(_postid);
        var email = req.session.user.f_uid;
        console.log(email);
        getPostQuery = `select * from posts, usersinfonew where postby=email and postid='${_postid}';`;
        console.log(getPostQuery);
        await pool.query(getPostQuery, async (error, result) => {
            if(error) {
                res.send(error);
            }
            var results = {'post': result.rows[0]};
            console.log(results);
            var getUserQuery = `select * from usersinfonew where email='${email}';`;
            console.log(getUserQuery);
            await pool.query(getUserQuery, async (error, result) => {
                if(error) {
                    res.send(error);
                }
                results.post["ufname"] = result.rows[0].fname;
                results.post["ulname"] = result.rows[0].lname;
                results.post["uemail"] = result.rows[0].email;
                console.log(results);
                var getlikeQuery = `select * from likesnew where id='${_postid}' and likedby='${email}';`;
                console.log(getlikeQuery);
                await pool.query(getlikeQuery, (error, result) => {
                    if(error) {
                        res.send(error);
                    }
                    if(result.rows.length === 0) {
                        results.post["id"] = "";
                        results.post["likedby"] = "";
                    }
                    else{
                        results.post["id"] = result.rows[0].id;
                        results.post["likedby"]= result.rows[0].likedby;
                    }
                    console.log(results);
                    res.render('pages/view_post_search', results);
                });
            });
        });
    }
    else {
        var _postid = req.params.id.substring(1);
        console.log(_postid);
        getPostQuery = `select * from posts, usersinfonew where postby=email and postid='${_postid}';`;
        console.log(getPostQuery);
        await pool.query(getPostQuery, (error, result) => {
        if(error) {
            res.send(error);
        }
        var results = {'post': result.rows[0]};
        console.log(results);
        res.render('pages/view_post_searchnon', results);
        });

    }
});
//
// USER_POST_VIEW for LIKED PAGE
//something going wrong here
app.get('/view_post_liked/:id', async (req, res) => {
    if(req.session.user) {
        var _postid = req.params.id.substring(1);
        console.log(_postid);
        var email = req.session.user.f_uid;
        console.log(email);
        getPostQuery = `select * from posts, usersinfonew where postby=email and postid='${_postid}';`;
        console.log(getPostQuery);
        await pool.query(getPostQuery, async (error, result) => {
            if(error) {
                res.send(error);
            }
            var results = {'post': result.rows[0]};
            console.log(results);
            var getUserQuery = `select * from usersinfonew where email='${email}';`;
            console.log(getUserQuery);
            await pool.query(getUserQuery, async (error, result) => {
                if(error) {
                    res.send(error);
                }
                results.post["ufname"] = result.rows[0].fname;
                results.post["ulname"] = result.rows[0].lname;
                results.post["uemail"] = result.rows[0].email;
                console.log(results);
                var getlikeQuery = `select * from likesnew where id='${_postid}' and likedby='${email}';`;
                console.log(getlikeQuery);
                await pool.query(getlikeQuery, (error, result) => {
                    if(error) {
                        res.send(error);
                    }
                    if(result.rows.length === 0) {
                        results.post["id"] = "";
                        results.post["likedby"] = "";
                    }
                    else{
                        results.post["id"] = result.rows[0].id;
                        results.post["likedby"]= result.rows[0].likedby;
                    }
                    console.log(results);
                    res.render('pages/view_post_liked', results);
                });
            });
        });
    }
    else {
        res.redirect('/login.html');
    }
})
// VIEW_POST for FAV PAGE
app.get('/view_post_favourites/:id', async (req, res) => {
    var _postid = req.params.id.substring(1);
    console.log(_postid);
    getPostQuery = `select * from posts, usersinfonew where postby=email and postid='${_postid}';`;
    console.log(getPostQuery);
    await pool.query(getPostQuery, (error, result) => {
        if(error) {
            res.send(error);
        }
        var results = {'post': result.rows[0]};
        console.log(results);
        res.render('pages/view', results);
    });
})


// USER_POST_UPDATE PAGE
app.get('/post_update/:id', async (req, res) => {
    if(req.session.user) {
        var _postid = req.params.id.substring(1);
        console.log(_postid);
        getPostQuery = `select * from posts, usersinfonew where postby=email and postid='${_postid}';`;
        console.log(getPostQuery);
        await pool.query(getPostQuery, (error, result) => {
            if(error) {
                res.send(error);
            }
            var results = {'post': result.rows[0]};
            console.log(results);
            res.render('pages/post_update', results);
        });
    }
    else{
        res.redirect('/login.html');
    }
})
//
app.post('/postUpDel/:arg', async (req, res) => {
    if(req.session.user) {
        console.log(req.params.arg);
        var _postid = req.params.arg.split(':')[1];
        console.log(_postid);
        var _postlikes = req.params.arg.split(':')[2];
        console.log(_postlikes);
        if(req.body.post_back != undefined) {
            res.redirect(`/view_post/:${_postid}`)
        }
        else if(req.body.post_delete != undefined) {
            var deletePostQuery = `delete from posts where postid='${_postid}';`;
            console.log(deletePostQuery);
            await pool.query(deletePostQuery, (error, result) => {
                if(error) {
                    res.end(error);
                }
                else {
                    res.redirect('/posts');
                }
            });
        }
        else if(req.body.post_update != undefined) {
            var email = req.body.f_emailForAdd;
            console.log(email);
            var rname = req.body.f_recipeName;
            console.log(rname);
            var rtime = req.body.f_recipeTime;
            console.log(rtime);
            var ringd = req.body.f_recipeIngd;
            console.log(ringd);
            var rinfo = req.body.f_recipeInfo;
            console.log(rinfo);
            var ringdlist = "";
            for(var i=1; i<=ringd; i++) {
                var temp = `req.body.f_ingd${i}`;
                ringdlist += eval(temp);
                ringdlist += ':';
            }
            console.log(ringdlist);
            var updatePostQuery =
            `update posts set postname='${rname}', postctime='${rtime}', postingd='${ringd}', postingdlist='${ringdlist}', postinfo='${rinfo}', postlikes='${_postlikes}' where postid='${_postid}' and postby='${email}';`;
            console.log(updatePostQuery);
            await pool.query(updatePostQuery, (error, result) => {
                if(error) {
                    res.end(error);
                }
                else {
                    res.redirect(`/view_post/:${_postid}`);
                }
            });
        }
    }
    else{
        res.redirect('/login.html');
    }
})

// app.post('/postUpDel/:arg', upload.single('recipeImg'), async (req, res) => {
//     if(req.session.user) {
//         //console.log(req.params.arg);
//         var _postid = req.params.arg.split(':')[1];
//         //console.log(_postid);
//         var _postlikes = req.params.arg.split(':')[2];
//         //console.log(_postlikes);
//
//         if(req.body.post_back != undefined) {
//             res.redirect(`/view_post/:${_postid}`)
//         }
//         else if(req.body.post_delete != undefined) {
//             var deletePostQuery = `delete from posts where postid='${_postid}';`;
//             //console.log(deletePostQuery);
//             await pool.query(deletePostQuery, (error, result) => {
//                 if(error) {
//                     res.end(error);
//                 }
//                 else {
//                     res.redirect('/posts')
//                 }
//             });
//         }
//         else if(req.body.post_update != undefined) {
//
//           var imagetagQuery = `SELECT imgtag FROM posts WHERE postid='${_postid}';`;
//           var imagetagresult = await pool.query(imagetagQuery);
//           console.log(imagetagresult.rows[0]);
//           var result = imagetagresult.rows[0];
//           console.log(result.imgtag);
//
//             if(result.imgtag == null) {
//                 console.log("updating with no image attached");
//                 const file = req.file;
//                 const uploadResults = await uploadFile(file);
//                 var imgkey = file.filename;
//                 var email = req.body.f_emailForAdd;
//                 var rname = req.body.f_recipeName;
//                 var rtime = req.body.f_recipeTime;
//                 var ringd = req.body.f_recipeIngd;
//                 var rinfo = req.body.f_recipeInfo;
//                 var ringdlist = "";
//                 for(var i=1; i<=ringd; i++) {
//                     var temp = `req.body.f_ingd${i}`;
//                     ringdlist += eval(temp);
//                     ringdlist += ':';
//                 }
//                 var updatePostQuery =
//                 `update posts set postname='${rname}', postctime='${rtime}', postingd='${ringd}', postingdlist='${ringdlist}', postinfo='${rinfo}', postlikes='${_postlikes}', imgtag='${imgkey}', validpost=TRUE where postid='${_postid}' and postby='${email}';`;
//                 console.log(updatePostQuery);
//                 await pool.query(updatePostQuery, (error, result) => {
//                     if(error) {
//                         res.end(error);
//                     }
//                     else {
//                         res.redirect(`/view_post/:${_postid}`);
//                     }
//                 });
//             }
//             else {
//                 console.log("updating with an image already posted");
//                 var email = req.body.f_emailForAdd;
//                 var rname = req.body.f_recipeName;
//                 var rtime = req.body.f_recipeTime;
//                 var ringd = req.body.f_recipeIngd;
//                 var rinfo = req.body.f_recipeInfo;
//                 var imgkey2 = result.imgtag;
//                 console.log(rinfo);
//                 for(var i=1; i<=ringd; i++) {
//                     var temp = `req.body.f_ingd${i}`;
//                     ringdlist += eval(temp);
//                     ringdlist += ':';
//                 }
//                 // console.log(ringdlist);
//                 var updatePostQuery =
//                 `update posts set postname='${rname}', postctime='${rtime}', postingd='${ringd}', postingdlist='${ringdlist}', postinfo='${rinfo}', postlikes='${_postlikes}', imgtag='${imgkey2}', validpost=TRUE where postid='${_postid}' and postby='${email}';`;
//                 // console.log(updatePostQuery);
//                 await pool.query(updatePostQuery, (error, result) => {
//                     if(error) {
//                         res.end(error);
//                     }
//                     else {
//                         res.redirect(`/view_post/:${_postid}`);
//                     }
//                 });
//             }
//         }
//     }
//     else{
//         res.redirect('/login.html');
//     }
// })


// LIKE & UNLIKE FUNCTIONS
app.post('/likeUnlike', async (req, res) => {
    if(req.session.user) {
        console.log("LIKEUNLIKE");
        console.log(req.body);
        var id = req.body.f_pid;
        console.log(id);
        var by = req.body.f_pby;
        console.log(by);
        var email = req.body.f_pemail;
        console.log(email);
        var likes = req.body.f_plikes;
        console.log(likes);
        var getLikeQuery = `select * from likesnew where id='${id}' and likedby='${email}';`;
        console.log(getLikeQuery);
        await pool.query(getLikeQuery, async (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = result.rows.length;
            console.log(results);
            if(parseInt(results) === 0) {
                // insert into likes table
                var insertLikeQuery = `insert into likesnew(id, by, likedby) values('${id}', '${by}', '${email}');`;
                console.log(insertLikeQuery);
                await pool.query(insertLikeQuery, async (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    // update likes_col in posts table: +1
                    likes = parseInt(likes) + 1;
                    var updateLikeQuery =
                    `update posts set postlikes=${likes} where postid='${id}' and postby='${by}';`;
                    console.log(updateLikeQuery);
                    await pool.query(updateLikeQuery, (error, result) => {
                        if(error) {
                            res.end(error);
                        }
                        res.redirect(`/view_post/:${id}`);
                    });
                });
            }
            else {
                // delete from likes table
                var deleteLikeQuery = `delete from likesnew where id='${id}' and likedby='${email}';`;
                console.log(deleteLikeQuery);
                await pool.query(deleteLikeQuery, async (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    // update likes_col in posts table: -1
                    likes = parseInt(likes) - 1;
                    var updateLikeQuery =
                    `update posts set postlikes=${likes} where postid='${id}' and postby='${by}';`;
                    console.log(updateLikeQuery);
                    await pool.query(updateLikeQuery, (error, result) => {
                        if(error) {
                            res.end(error);
                        }
                        res.redirect(`/view_post/:${id}`);
                    });
                });
            }
        });
    }
    else {
        res.redirect('/login.html');
    }
})
// LIKED
app.post('/likeUnlike_liked', async (req, res) => {
    if(req.session.user) {
        console.log(req.body);
        var id = req.body.f_pid;
        console.log(id);
        var by = req.body.f_pby;
        console.log(by);
        var email = req.body.f_pemail;
        console.log(email);
        var likes = req.body.f_plikes;
        console.log(likes);
        var getLikeQuery = `select * from likesnew where id='${id}' and likedby='${email}';`;
        console.log(getLikeQuery);
        await pool.query(getLikeQuery, async (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = result.rows.length;
            console.log(results);
            if(parseInt(results) === 0) {
                // insert into likes table
                var insertLikeQuery = `insert into likesnew(id, by, likedby) values('${id}', '${by}', '${email}');`;
                console.log(insertLikeQuery);
                await pool.query(insertLikeQuery, async (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    // update likes_col in posts table: +1
                    likes = parseInt(likes) + 1;
                    var updateLikeQuery =
                    `update posts set postlikes=${likes} where postid='${id}' and postby='${by}';`;
                    console.log(updateLikeQuery);
                    await pool.query(updateLikeQuery, (error, result) => {
                        if(error) {
                            res.end(error);
                        }
                        res.redirect(`/view_post_liked/:${id}`);
                    });
                });
            }
            else {
                // delete from likes table
                var deleteLikeQuery = `delete from likesnew where id='${id}' and likedby='${email}';`;
                console.log(deleteLikeQuery);
                await pool.query(deleteLikeQuery, async (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    // update likes_col in posts table: -1
                    likes = parseInt(likes) - 1;
                    var updateLikeQuery =
                    `update posts set postlikes=${likes} where postid='${id}' and postby='${by}';`;
                    console.log(updateLikeQuery);
                    await pool.query(updateLikeQuery, (error, result) => {
                        if(error) {
                            res.end(error);
                        }
                        res.redirect(`/view_post_liked/:${id}`);
                    });
                });
            }
        });
    }
    else {
        res.redirect('/login.html');
    }
})
// FAV
app.post('/likeUnlike_fav', async (req, res) => {
    if(req.session.user) {
        console.log(req.body);
        var id = req.body.f_pid;
        console.log(id);
        var by = req.body.f_pby;
        console.log(by);
        var email = req.body.f_pemail;
        console.log(email);
        var likes = req.body.f_plikes;
        console.log(likes);
        var getLikeQuery = `select * from likesnew where id='${id}' and likedby='${email}';`;
        console.log(getLikeQuery);
        await pool.query(getLikeQuery, async (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = result.rows.length;
            console.log(results);
            if(parseInt(results) === 0) {
                // insert into likes table
                var insertLikeQuery = `insert into likesnew(id, by, likedby) values('${id}', '${by}', '${email}');`;
                console.log(insertLikeQuery);
                await pool.query(insertLikeQuery, async (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    // update likes_col in posts table: +1
                    likes = parseInt(likes) + 1;
                    var updateLikeQuery =
                    `update posts set postlikes=${likes} where postid='${id}' and postby='${by}';`;
                    console.log(updateLikeQuery);
                    await pool.query(updateLikeQuery, (error, result) => {
                        if(error) {
                            res.end(error);
                        }
                        res.redirect(`/view_post_fav/:${id}`);
                    });
                });
            }
            else {
                // delete from likes table
                var deleteLikeQuery = `delete from likesnew where id='${id}' and likedby='${email}';`;
                console.log(deleteLikeQuery);
                await pool.query(deleteLikeQuery, async (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    // update likes_col in posts table: -1
                    likes = parseInt(likes) - 1;
                    var updateLikeQuery =
                    `update posts set postlikes=${likes} where postid='${id}' and postby='${by}';`;
                    console.log(updateLikeQuery);
                    await pool.query(updateLikeQuery, (error, result) => {
                        if(error) {
                            res.end(error);
                        }
                        res.redirect(`/view_post_fav/:${id}`);
                    });
                });
            }
        });
    }
    else {
        res.redirect('/login.html');
    }
})
//SEARCH
app.post('/likeUnlike_search', async (req, res) => {
    if(req.session.user) {
        console.log(req.body);
        var id = req.body.f_pid;
        console.log(id);
        var by = req.body.f_pby;
        console.log(by);
        var email = req.body.f_pemail;
        console.log(email);
        var likes = req.body.f_plikes;
        console.log(likes);
        var getLikeQuery = `select * from likesnew where id='${id}' and likedby='${email}';`;
        console.log(getLikeQuery);
        await pool.query(getLikeQuery, async (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = result.rows.length;
            console.log(results);
            if(parseInt(results) === 0) {
                // insert into likes table
                var insertLikeQuery = `insert into likesnew(id, by, likedby) values('${id}', '${by}', '${email}');`;
                console.log(insertLikeQuery);
                await pool.query(insertLikeQuery, async (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    // update likes_col in posts table: +1
                    likes = parseInt(likes) + 1;
                    var updateLikeQuery =
                    `update posts set postlikes=${likes} where postid='${id}' and postby='${by}';`;
                    console.log(updateLikeQuery);
                    await pool.query(updateLikeQuery, (error, result) => {
                        if(error) {
                            res.end(error);
                        }
                        res.redirect(`/view_post_search/:${id}`);
                    });
                });
            }
            else {
                // delete from likes table
                var deleteLikeQuery = `delete from likesnew where id='${id}' and likedby='${email}';`;
                console.log(deleteLikeQuery);
                await pool.query(deleteLikeQuery, async (error, result) => {
                    if(error) {
                        res.end(error);
                    }
                    // update likes_col in posts table: -1
                    likes = parseInt(likes) - 1;
                    var updateLikeQuery =
                    `update posts set postlikes=${likes} where postid='${id}' and postby='${by}';`;
                    console.log(updateLikeQuery);
                    await pool.query(updateLikeQuery, (error, result) => {
                        if(error) {
                            res.end(error);
                        }
                        res.redirect(`/view_post_search/:${id}`);
                    });
                });
            }
        });
    }
    else {
        res.redirect('/login.html');
    }
})

// USER FAVOURITES PAGE
app.get('/favourites', async (req, res) => {
    if(req.session.user) {
        var getPostsQuery = `select * from posts order by postlikes desc;`;
        console.log(getPostsQuery);
        await pool.query(getPostsQuery, async (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'posts': result.rows};
            // 20 most liked recipes
            console.log(result.rows.length);
            if(result.rows.length > 20) {
                results.posts.slice(0,20);
            }
            console.log(results.posts.length);
            console.log(results);
            var email = req.session.user.f_uid;
            console.log(email);
            var getUserQuery = `select * from usersinfonew where email='${email}';`;
            console.log(getUserQuery);
            await pool.query(getUserQuery, (error, result) => {
                if(error) {
                    res.end(error);
                }
                results["fname"] = result.rows[0].fname;
                results["lname"] = result.rows[0].lname;
                console.log(results);
                res.render('pages/user_favourites', results);
            });
        });
    }
    else {
        var getPostsQuery = `select * from posts order by postlikes desc;`;
        console.log(getPostsQuery);
        await pool.query(getPostsQuery, (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'posts': result.rows};
            // 20 most liked recipes
            console.log(result.rows.length);
            if(result.rows.length > 20) {
                results.posts.slice(0,20);
            }
            console.log(results.posts.length);
            console.log(results);
            res.render('pages/favourites', results);
        });
    }
})


// USER LIKED PAGE
app.get('/liked', async (req, res) => {
    if(req.session.user) {
        var email = req.session.user.f_uid;
        console.log(email);
        var getPostsQuery = `select * from likesnew, posts where id=postid and likedby='${email}';`;
        console.log(getPostsQuery);
        await pool.query(getPostsQuery, async (error, result) => {
            if(error) {
                res.end(error);
            }
            var results = {'posts': result.rows};
            console.log(results);
            var getUserQuery = `select * from usersinfonew where email='${email}';`;
            console.log(getUserQuery);
            await pool.query(getUserQuery, (error, result) => {
                if(error) {
                    res.end(error);
                }
                results["fname"] = result.rows[0].fname;
                results["lname"] = result.rows[0].lname;
                console.log(results);
                res.render('pages/user_liked', results);
            });
        });
    }
    else {
        res.redirect('/login.html');
    }
})


//ADMIN - BLOCK USER
app.post('/blockUser', async (req, res) => {
    console.log(req.body);
    var blocked = req.body.blockedEmail;
    console.log(blocked);
    console.log(req.body.blockStatus);
    if(req.body.blockStatus == "block") {
        var blockUserQuery = `update usersinfonew set valid = false where email = '${blocked}'`;
    }
    else {
        var blockUserQuery = `update usersinfonew set valid = true where email = '${blocked}'`;
    }
    try {
        const result = await pool.query(blockUserQuery);
        res.redirect('/admin_users');
    }
    catch(e) {
        res.send(e);
    }
});

//ADMIN - BLOCK POST
app.post('/blockPost', async (req, res) => {
    var blocked = req.body.blockedId;
    if(req.body.blockStatus == "Restrict") {
        var blockPostQuery = `update posts set validpost = false where postid = '${blocked}'`;
    }
    else {
        var blockPostQuery = `update posts set validpost = true where postid = '${blocked}'`;
    }
    try {
        const result  = await pool.query(blockPostQuery);
        res.redirect('/admin_posts');
    }
    catch(e) {
        res.send(e);
    }
});

// APP PORT
app.listen(PORT, () => console.log(`Listening on ${ PORT }`));

module.exports = app




// test page
app.get('/test', (req, res) => {
    res.redirect('/test.html')
})
