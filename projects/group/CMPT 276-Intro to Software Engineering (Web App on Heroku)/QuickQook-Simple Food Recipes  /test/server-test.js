var chai = require('chai');
var chaiHttp = require('chai-http');
var server = require('../index');
var should = chai.should();
var request = require('supertest');
const { onFinish } = require('tape');
var expect = require('chai').expect;

chai.use(chaiHttp);

describe('1. Users', function(){

  //User has filled out the sign up form succesfully
  it(' 1.1 page should redirect to /login.html after a succesful POST request for /userSignup', function(done){
    chai.request(server).post('/userSignup').send({'f_fname':'test', 'f_lname':'name', 'f_bday':'1999-07-07', 'f_gender':'male', 'f_occupation':'student', 'f_email':'dudaramahd@live.ca', 'f_pass':'123456'})
      .end(function(error,res){
        res.should.have.status(200);
        // res.expect('Location', '/login.html');
        // expect(res.headers.location).to.include('/login.html');
        done();
      });
    });

      //A regular user has succesfully logged in
      it('1.2 page should redirect to /profile after a succesful POST request for /userLogin', function(done){
        chai.request(server).post('/userLogin').send({'f_uid':'vm@ent.com', 'f_upass':'123456'})
          .end(function(error,res){
            res.should.have.status(200);
            done();
          });
        });

        //An admin user has succesfully logged in
        it('1.3 page should redirect to /admin after a succesful POST request for /userLogin', function(done){
          chai.request(server).post('/userLogin').send({'f_uid':'asifh@sfu.ca', 'f_upass':'110046'})
            .end(function(error,res){
              res.should.have.status(200);
              done();
            });
          });

          it('1.4 should not let a blocked user login', function(done){
            chai.request(server).post('/userLogin').send({'f_uid':'test3@sfu.ca', 'f_upass':'123456'})
              .end(function(error,res){
                res.should.have.status(200);
                done();
              });
            });

            it('1.5 should not let an unregistered user login', function(done){
              chai.request(server).post('/userLogin').send({'f_uid':'thisonedoesnotexist@sfu.ca', 'f_upass':'dumbguess123'})
                .end(function(error,res){
                  res.should.redirect;
                  res.should.have.status(200);
                  done();
                });
              });

});

describe('2. Recipes', function(){

  const userCredentials = {'f_uid':'asifh@sfu.ca', 'f_upass':'110046', 'f_isadmin':'off'}
  var authenticatedUser = request.agent(server);

  before(function(done){
    authenticatedUser
      .post('/userLogin')
      .send(userCredentials)
      .end(function(err, response){
        expect(response.statusCode).to.equal(302);
        done();
      });
    });

  //Any visitor to the user searches for a recipe after entering at least 3 ingredients
  // it('2.1 should redirect any user to /searchRecipe after a succesful POST request for /searchRecipe from the homepage', function(done){
  //   chai.request(server).post('/qqviewRecipe').send({"rId":"qq3RAi"})
  //   .end(function(error, res){
  //     res.should.have.status(200);
  //   });
  //   done();
  // });


  // it('2.2 should redirect a logged in user to /profile after a succesful POST request for /addRecipies', function(done){
  //   let recipeInfo = {'f_emailForAdd':'asifh@sfu.ca', 'f_recipeName':'Spagehetti', 'f_recipeTime':15, 'f_recipeIngd':1, 'f_ingd1':'Spaghetti', 'f_recipeInfo':'a very good meal comprised of spaghetti straws and the pasta sauce of your choice'};

  //   authenticatedUser.post('/addRecipePost').send(recipeInfo)
  //   // .redirects(1)
  //   .end(function(error, response) {
  //     expect(response).to.have.status(302);
  //     // expect(response.req.path).to.include('/profile');
  //     done();
  //   });
  // });

  // A user with an account is able to view their recipes which they have added to the database
  // by navigating from /addRecipe to /posts
  // NEED TO IMPLEMENT
  it('2.3 should allow a user with an account to view their recipes which they have added to the database by navigating from /addRecipe to /posts', function(done){
    authenticatedUser.get('/posts')
    .end(function(error, response){
      response.should.have.status(200);
      done();
    })
  });

  it('2.4 should allow a user to like/unlike a post', function(done){
    let likesData = {
      post_like: 'Like',
      f_pid: 'qq8hoh',
      f_pby: 'test1@sfu.ca',
      f_pemail: 'test1@sfu.ca',
      f_plikes: '9',
      f_plikedby: ''
    };
    authenticatedUser.post('/likeUnlike').send(likesData)
    .end(function(error, response) {
      // console.log(response)
      response.should.redirect;
      //response.headers.location.should.include('/view_post/')
      done();
    });
  });

  it('2.5 should allow a user to view liked posts by navigating to /liked', function(done){
    authenticatedUser.get('/liked')
    .end(function(error, response) {
      response.should.have.status(200);
      done();
    });
  });

  it('2.6 should allow a user to view most popular recipes by navigating to favourites', function(done){
    authenticatedUser.get('/favourites')
    .end(function(error, response) {
      response.should.have.status(200);
      done();
    });
  });
});


describe('3. Admin Tasks', function(){

  const adminCredentials = {
    f_uid: 'asifh@sfu.ca',
    f_upass: '110046',
    f_isadmin: 'on',
    f_login: 'Login'
  };
  var authenticatedAdmin = request.agent(server);

  before(function(done){
    authenticatedAdmin
      .post('/userLogin')
      .send(adminCredentials)
      .end(function(err, response){
        expect(response.statusCode).to.equal(302);
        done();
      });
    });

  it('3.1 should allow an admin to block a user as per requirements', function(done){
    let blockData = {
      blockedEmail: 'asif@test.qq',
      blockStatus: 'block'
    };
    authenticatedAdmin.post('/blockUser').send(blockData)
    .redirects(1)
    .end(function(error, response){
      response.should.have.status(200);
      done();
    });
  });

  it('3.2 should allow an admin to unblock a user as per requirements', function(done){
    let blockData = {
      blockedEmail: 'asif@test.qq',
      blockStatus: 'unblock'
    };
    authenticatedAdmin.post('/blockUser').send(blockData)
    .redirects(1)
    .end(function(error, response){
      response.should.have.status(200);
      done();
    });
  });

  it('3.3 should not let an unregistered user access the block function', function(done){
    let blockData = {
      blockedEmail: 'asif@test.qq',
      blockStatus: 'unblock'
    };
    chai.request(server).post('/blockUser').send(blockData)
    .redirects(2)
    .end(function(error, response){
      // console.log(response.path);
      response.should.have.status(200);
      // expect(response.header.path).to.equal("/login.html");
      done();
    });
  });


});
