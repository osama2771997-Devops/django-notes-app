
pipeline {
    agent any

    stages {

        stage('Clone the Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/osama2771997-Devops/django-notes-app.git'
            }
        }

        stage('Create Virtual Environment') {
            steps {
                sh 'python3 -m venv django'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    django/bin/python -m pip install --upgrade pip
                    django/bin/pip install -r requirements.txt

                    # Fix Gunicorn pkg_resources error
                    django/bin/python -m pip install setuptools==80.9.0
                '''
            }
        }

        stage('Run Django Migrations') {
            steps {
                sh 'django/bin/python manage.py migrate'
            }
        }

        stage('Test Django Application') {
            steps {
                sh 'django/bin/python manage.py check'
            }
        }

        stage('Run Django App') {
            steps {
                sh '''
                    # Stop previously running Gunicorn process
                    pkill -f '[g]unicorn notesapp.wsgi:application' || true

                    # Start Gunicorn in background
                    nohup ./django/bin/gunicorn \
                    notesapp.wsgi:application \
                    --bind 0.0.0.0:8000 \
                    --workers 3 \
                    --pid gunicorn.pid \
                    > gunicorn.log 2>&1 < /dev/null &

                    # Give Gunicorn time to start
                    sleep 3

                    # Verify Gunicorn is running
                    if ! kill -0 "$(cat gunicorn.pid)" 2>/dev/null; then
                        echo "Gunicorn failed to start!"
                        cat gunicorn.log
                        exit 1
                    fi

                    echo "Django application started successfully!"
                '''
            }
        }
    }

    post {
        success {
            echo 'Django application deployed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check Jenkins console output.'
        }
    }
    stage('Run Django App') {
    steps {
        sh '''
            sudo systemctl restart django-notes
            sudo systemctl status django-notes --no-pager
        '''
    }
}
}
