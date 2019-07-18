pipeline{
    agent any
    parameters {
		string(name: 'Modular', defaultValue: '', description: 'support notebook,training,serving.')
		string(name: 'Framework', defaultValue: '', description: 'tensorflow,pytorch.')
		string(name: 'Framework_Version', defaultValue: '', description: '')
		string(name: 'Keras_Version', defaultValue: '', description: 'used for tensorflow framework')
		string(name: 'Gpu', defaultValue: '', description: 'true or false')
		string(name: 'IMAGE_REGISTRY', defaultValue: 'index.alauda.cn', description: 'index.alauda.cn')
		string(name: 'IMAGE_OWNER', defaultValue: '', description: 'alaudak8s')
		string(name: 'IMAGE_TAG', defaultValue: '', description: 'The tag used for the new version of the component.')
		string(name: 'ENV', defaultValue: 'test', description: 'Environment used to publish the chart.')
		booleanParam(name: 'DEBUG', defaultValue: true, description: 'Debugging a pipeline will not cause real changes in the repo or in the chart repository.')
		booleanParam(name: 'STABLE', defaultValue: false, description: 'Is a stable version publishing.')
		string(name: 'GIT_TAG', defaultValue: '', description: 'The tag of the chart.')
		string(name: 'BRANCH', defaultValue: 'master', description: 'Branch to be used by the chart.')
		string(name: 'PR_CHANGE_BRANCH', defaultValue: 'master', description: 'Branch that which merge from when trigger by a pr change')
		string(name: 'PRODUCT', defaultValue: 'acp', description: 'The product , it supports acp or aml now')
	}


    stages{
        stage('prepare'){
            steps{
                library identifier: 'genimage-sharelib@master', retriever: modernSCM(
                [$class: 'GitSCMSource',
                remote: 'https://github.com/fyuan1316/gen-image-sharelib.git',
                credentialsId: ''])
                script{
                    echo "pre"
                    def map=['script':'im a script']

                    def cfg = readYaml file: 'config.yaml' 
                    def out = img.genSh(cfg.base-notebook.script)
                    println out
                }
            }
        }
        stage('gen-images'){
            steps{
                script{
                    echo "gen images"
                }
            }
        }
        stage('push-images'){
            steps{
                script{
                    echo "push images"
                }
            }
        }
        
    }
}