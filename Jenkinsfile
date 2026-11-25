
pipeline {
    agent any

    environment {
        APP_DIR = '/django-notes-app'
        VENV_DIR = '/django-notes-app/django'
        SERVICE_NAME = 'django-notes'
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/osama2771997-Devops/django-notes-app.git'
            }
        }

        stage('Create Virtual Environment') {
            steps {
                sh '''
                    python3 -m venv django
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    django/bin/python -m pip install --upgrade pip
                    django/bin/python -m pip install setuptools==80.9.0
                    django/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Run Database Migrations') {
            steps {
                sh '''
                    django/bin/python manage.py migrate
                '''
            }
        }

        stage('Test Django Application') {
            steps {
                sh '''
                    django/bin/python manage.py check
                '''
            }
        }

        stage('Deploy Django Application') {
            steps {
                sh '''
                    sudo systemctl restart django-notes
                    sudo systemctl status django-notes --no-pager
                '''
            }
        }
    }

    post {
        success {
            echo 'Django application deployed successfully!'
        }

        failure {
            echo 'Deployment failed. Please check the Jenkins console output.'
        }
    }
}
