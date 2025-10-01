This pipeline execute a set of funtions, check next list:

	  1- Set up enviroments for Docker and Python
	  2- Login in AWS Autentication with AWS OIDC STS 
	  3- Autentication with User Keys Acess
	  4- Access to ECR 
	  5- Create image and testing container

For its functions it need different configurations in AWS and GitHub enviroment, here the list of uses services in AWS and configurations GitHub:

  -AWS
  
    1- ECR
    2- IAM
    3- IAM Provider Identity
    4- AWS Shell

  -GitHub
  
    1- CI/CD Actions
    2- Uses Actions Github
    3- Markeplace Git Hub Actions
    4- Secret Repository

Main configurations related to autentication:
1- IAM | Create User and generate user and par keys
(User - Create User)
<img width="1592" height="306" alt="image" src="https://github.com/user-attachments/assets/404680ac-7277-4016-8ad0-a1b7acab6732" />

(User - Generate access key)
<img width="1561" height="753" alt="image" src="https://github.com/user-attachments/assets/1caa9e65-d751-4dd8-ae5f-8329f528c3ab" />

2- IAM | IF YOU NEED STS AUTENTICATION 
  *NOTE*: This is not applicable for you pipeline because this solution only management manual credentials for to autenticate, its not is compatible with github for storage in time execution you secrets credential, only you should uses this for management specifics permissions or roles attach to an user o account in general.
  
  - Create 'trust policy' and atthat to rosource role for example 'ecr resource'
  - Atthat your police to user
  - And in your AWS Shell execute this commands for to request ACCESS TOKEN, and this should return, something similar to this image
    
		𝐚𝐰𝐬 𝐬𝐭𝐬 𝐚𝐬𝐬𝐮𝐦𝐞-𝐫𝐨𝐥𝐞 \
		  --𝐫𝐨𝐥𝐞-𝐚𝐫𝐧 𝐚𝐫𝐧:𝐚𝐰𝐬:𝐢𝐚𝐦::𝟒𝟑𝟗𝟏𝟓𝟐𝟑𝟏𝟐𝟕𝟓𝟐:𝐫𝐨𝐥𝐞/𝐒𝐓𝐒𝐓-𝐑𝐎𝐋 \
		  --𝐫𝐨𝐥𝐞-𝐬𝐞𝐬𝐬𝐢𝐨𝐧-𝐧𝐚𝐦𝐞 𝐠𝐢𝐭𝐡𝐮𝐛𝐒𝐞𝐬𝐬𝐢𝐨𝐧 \
		  --𝐝𝐮𝐫𝐚𝐭𝐢𝐨𝐧-𝐬𝐞𝐜𝐨𝐧𝐝𝐬 𝟑𝟔𝟎𝟎 > 𝐚𝐬𝐬𝐮𝐦𝐞‧𝐣𝐬𝐨𝐧
<img width="1906" height="300" alt="GENERACION DEL TOKEN" src="https://github.com/user-attachments/assets/2ab8ffc4-98e5-4c21-9e9d-25e2bdccfc0a" />
  - Export the credential to vars on file using
    
		export AWS_ACCESS_KEY_ID=$(jq -r .Credentials.AccessKeyId assume.json)
		export AWS_SECRET_ACCESS_KEY=$(jq -r .Credentials.SecretAccessKey assume.json)
		export AWS_SESSION_TOKEN=$(jq -r .Credentials.SessionToken assume.json)

<img width="675" height="46" alt="JSONEXPORT" src="https://github.com/user-attachments/assets/23f464d8-f817-42c6-acc7-f97af08c02bc" />

  - Test you credentials to access a you resource
<img width="595" height="192" alt="LIST INFORMATION - LAST ASIGNED STS" src="https://github.com/user-attachments/assets/f4ce00ff-fddb-4caa-9343-a3d4f317b11a" />

  
3- IAM | IF YOU NEED OIDC Provider 
 *NOTE*: This solution is applicable for this pipeline because OIDC Provider is use for to integrate automate-process as a pipeline and even it allow to integrate with other OIDC Provider
 
  - Create you provider OIDC
<img width="1895" height="373" alt="image" src="https://github.com/user-attachments/assets/476c9166-27f4-4a5f-ae31-31c555736593" />
  - Enter this data
<img width="1852" height="515" alt="image" src="https://github.com/user-attachments/assets/4066411d-1d7a-4060-be62-9b751a738272" />
  - Attach to rol thrus police
<img width="1607" height="582" alt="image" src="https://github.com/user-attachments/assets/0ddae1e8-c89f-4c6b-9ccc-1f3903e2e6ca" />
  - Enter you org, repo, if you want allow only the access for this repo or even you can regulary the access for the branch
<img width="1458" height="792" alt="image" src="https://github.com/user-attachments/assets/8c10fdf9-4afe-4a6f-8053-7e9a0bd09c79" />
- Atthach a rol to the rosources which you want access
<img width="1225" height="642" alt="image" src="https://github.com/user-attachments/assets/48b7fb1f-cd2f-4e50-8467-ee277a7b6172" />
- Assigne a name to rol, and you can see the JSON generated, where describe all your rol, your permission, access conditional etc...
<img width="1511" height="795" alt="image" src="https://github.com/user-attachments/assets/02f0e62c-6b33-4229-8d44-efc158854801" />


3.1- GitHub | Configure into you pipeline for access to this OIDC
  - use the uses solutions AWS for  to autenticate with you OIDC provider, in the field 'role-to-assume' enter you ARN role create previously
  *NOTE*: You should to use a secret for storage the arn-role value

      - name: Configure AWS credentials via OIDC
        uses: aws-actions/configure-aws-credentials@v4.1.0
        with:
          aws-region: us-east-2
          role-to-assume: arn:aws:iam::439152312752:role/git-hub-action-role
  - In you execution you should to have an ouput as this
<img width="1466" height="107" alt="image" src="https://github.com/user-attachments/assets/fa3e1245-39f7-412c-862d-07a149905b6b" />


4.0- GitHub| IF YOU WANT AUTENTICATE USING ACCESS KEY
  - With the access key generated previously in you user, you should storage this information as SECRETS in you Repository Secrets, ENV, etc
<img width="1167" height="196" alt="image" src="https://github.com/user-attachments/assets/09607331-24e8-4d37-81e2-2b8b0620464e" />

  - Use your secrets credential for autenticate using this action
    
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with: 
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-2
  - In you execution you should to have an ouput as this
<img width="1501" height="97" alt="image" src="https://github.com/user-attachments/assets/8a28f7bc-c16f-4144-9c42-091822705f2d" />


































  
