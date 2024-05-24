1. Open ip:9000 for sonarqube web.
2. Or set up url with nginx.
3. Create project and copy its commands
-sonar-scanner   -Dsonar.projectKey=testing   -Dsonar.sources=/opt/repo   -Dsonar.host.url=https://sonarqube.site   -Dsonar.login=admin    -Dsonar.password=password
Or
-sonar-scanner   -Dsonar.projectKey=testing   -Dsonar.sources=/opt/repo   -Dsonar.host.url=https://sonarqube.site   -Dsonar.token=sqp_7662457500e98f836f6f45e2df1cb8108

#for some reason when i tested, token wouldn't work.