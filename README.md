Project 1: Bare Metal Forms and Helpers
In this project, you’ll build a form the old fashioned way and then the Rails way.

Your Task
Set up the Back End
You’ll get good at setting up apps quickly in the coming lessons by using more or less this same series of steps (though we’ll help you less and less each time):

Build a new rails app (called “re-former”).
Go into the folder and create a new git repo there. Check in and commit the initial stuff.
Modify your README file to say something you’ll remember later, like “This is part of the Forms Project in The Odin Project’s Ruby on Rails Curriculum. Find it at http://www.theodinproject.com”
Create and migrate a User model with :username, :email and :password.
Add validations for presence to each field in the model.
Create the :users resource in your routes file so requests actually have somewhere to go. Use the :only option to specify just the :new and :create actions.
Build a new UsersController (either manually or via the $ rails generate controller Users generator).
Write empty methods for #new and #create in your UsersController.
Create your #new view in app/views/users/new.html.erb.
Fire up a rails server in another tab.
Make sure everything works by visiting http://localhost:3000/users/new in the browser.
HTML Form
The first form you build will be mostly HTML (remember that stuff at all?). Build it in your New view at app/views/users/new.html.erb. The goal is to build a form that is almost identical to what you’d get by using a Rails helper so you can see how it’s done behind the scenes.

Build a form for creating a new user. See the w3 docs for forms if you’ve totally forgotten how they work. Specify the method and the action attributes in your <form> tag (use $ rake routes to see which HTTP method and path are being expected based on the resource you created). Include the attribute accept-charset="UTF-8" as well, which Rails naturally adds to its forms to specify Unicode character encoding.
Create the proper input tags for your user’s fields (email, username and password). Use the proper password input for “password”. Be sure to specify the name attribute for these inputs. Make label tags which correspond to each field.
Submit your form and view the server output. Oops, we don’t have the right CSRF authenticity token (ActionController::InvalidAuthenticityToken) to protect against cross site scripting attacks and form hijacking. If you do not get an error, you used the wrong method from step 1.
Include your own authenticity token by adding a special hidden input and using the #form_authenticity_token method. This method actually checks the session token that Rails has stored for that user (behind the scenes) and puts it into the form so it’s able to verify that it’s actually you submitting the form. It might look like:

# app/views/users/new.html.erb
<input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
Submit the form again. Great! Success! We got a Template is missing error instead and that’s A-OK because it means that we’ve successfully gotten through our blank #create action in the controller (and didn’t specify what should happen next, which is why Rails is looking for a app/views/users/create.html.erb view by default). Look at the server output above the error’s stack trace. It should include the parameters that were submitted, looking something like:

Started POST "/users" for 127.0.0.1 at 2013-12-12 13:04:19 -0800
Processing by UsersController#create as HTML
Parameters: {"authenticity_token"=>"WUaJBOpLhFo3Mt2vlEmPQ93zMv53sDk6WFzZ2YJJQ0M=", "username"=>"foobar", "email"=>"foo@bar.com", "password"=>"[FILTERED]"}
That looks a whole lot like what you normally see when Rails does it, right?

Go into your UsersController and build out the #create action to take those parameters and create a new User from them. If you successfully save the user, you should redirect back to the New User form (which will be blank) and if you don’t, it should render the :new form again (but it will still have the existing information entered in it). You should be able to use something like:

# app/controllers/users_controller.rb
def create
  @user = User.new(username: params[:username], email: params[:email], password: params[:password])

  if @user.save
    redirect_to new_user_path
  else
    render :new
  end
end
Test this out – can you now create users with your form? If so, you should see an INSERT SQL command in the server log.
We’re not done just yet… that looks too long and difficult to build a user with all those params calls. It’d be a whole lot easier if we could just use a hash of the user’s attributes so we could just say something like User.new(user_params). Let’s build it… we need our form to submit a hash of attributes that will be used to create a user, just like we would with Rails’ form_for method. Remember, that method submits a top level user field which actually points to a hash of values. This is simple to achieve, though – just change the name attribute slightly. Nest your three User fields inside the variable attribute using brackets in their names, e.g. name="user[email]".
Resubmit. Now your user parameters should be nested under the "user" key like:

Parameters: {"authenticity_token" => "WUaJBOpLhFo3Mt2vlEmPQ93zMv53sDk6WFzZ2YJJQ0M=", "user" =>{ "username" => "foobar", "email" => "foo@bar.com", "password" => "[FILTERED]" } }
You’ll get some errors because now your controller will need to change. But recall that we’re no longer allowed to just directly call params[:user] because that would return a hash and Rails’ security features prevent us from doing that without first validating it.
Go into your controller and comment out the line in your #create action where you instantiated a ::new User (we’ll use it later).
Implement a private method at the bottom called user_params which will permit and require the proper fields (see the Controllers Lesson for a refresher).
Add a new ::new User line which makes use of that new whitelisting params method.
Submit your form now. It should work marvelously (once you debug your typos)!
Railsy Forms with #form_tag
Now we’ll start morphing our form into a full Rails form using the #form_tag and #*_tag helpers. There’s actually very little additional help that’s going on and you’ll find that you’re mostly just renaming HTML tags into Rails tags.

Comment out your entire HTML form. It may be helpful to save it for later on if you get stuck.
Convert your <form> tag to use a #form_tag helper and all of your inputs into the proper helper tags via #*_tag methods. The good thing is that you no longer need the authentication token because Rails will insert that for you automatically.
See the Form Tag API Documentation for a list and usage of all the input methods you can use with #form_tag.
Test out your form. You’ll need to change your #create method in the controller to once again accept normal top level User attributes, so uncomment the old User.new line and comment out the newer one.
You’ve just finished the first step.
Railsy-er Forms with #form_for
#form_tag probably didn’t feel that useful – it’s about the same amount of work as using <form>, though it does take care of the authenticity token stuff for you. Now we’ll convert that into #form_for, which will make use of our model objects to build the form.

Modify your #new action in the controller to instantiate a blank User object and store it in an instance variable called @user.
Comment out your #form_tag form in the app/views/users/new.html.erb view (so now you should have TWO commented out form examples).
Rebuild the form using #form_for and the @user from your controller.
Play with the #input method options – add a default placeholder (like “example@example.com” for the email field), make it generate a different label than the default one (like “Your user name here”), and try starting with a value already populated. Some of these things you may need to Google for, but check out the #form_for Rails API docs
Test it out. You’ll need to switch your controller’s #create method again to accept the nested :user hash from params.
Editing
Update your routes and controller to handle editing an existing user. You’ll need your controller to find a user based on the submitted params ID.
Create the Edit view at app/views/users/edit.html.erb and copy/paste your form from the New view. Your HTML and #form_tag forms (which should still be commented out) will not work – they will submit the form as a POST request when you need it to be a PATCH (PUT) request (remember your $ rake routes?). It’s an easy fix, which you should be able to see if you attempt to edit a user with the #form_for form (which is smart enough to know if you’re trying to edit a user or creating a new one).
Do a “view source” on the form generated by #form_for in your Edit view, paying particular attention to the hidden fields at the top nested inside the <div>. See it?
Try submitting an edit that you know will fail your validations. #form_for also automatically wraps your form in some formatting (e.g. a red border on the input field) if it detects errors with a given field.
Save this project to Git and upload to Github.
Extra Credit
Modify your form view to display a list of the error messages that are attached to your failed model object if you fail validations. Recall the #errors and #full_messages methods. Start by displaying them at the top and then modify