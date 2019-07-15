

to deploy your app:

- change database to pg
- to the yml file add test and production next to development
- - to production add the url and point to the environment variable
- push everything to git
- go to heroku
- in terminal do : sudo snap install --classic heroku
- - then: heroku login
- - heroku create anyname
- - git push heroku master
- - heroku run rake db:migrate
then run your website


for logs:
heroku logs --tail

for hours left:
heroku ps
