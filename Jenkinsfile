pipeline{
    agent any
    parameters {
		string(name: 'Target', defaultValue: 'baseNotebook', description: 'Image build target e.g. baseNotebook')
		string(name: 'Framework', defaultValue: '', description: 'tensorflow,pytorch.')
		string(name: 'Framework_Version', defaultValue: '', description: '')
		string(name: 'Keras_Version', defaultValue: '', description: 'used for tensorflow framework')
		string(name: 'Gpu', defaultValue: '', description: 'true or false')
		string(name: 'IMAGE_REGISTRY', defaultValue: 'index.alauda.cn', description: 'index.alauda.cn')
		string(name: 'IMAGE_OWNER', defaultValue: '', description: 'alaudak8s')

		string(name: 'REGISTRY', defaultValue: 'index.alauda.cn', description: '')
		string(name: 'OWNER', defaultValue: 'alaudaorg', description: '')
		string(name: 'ImageName', defaultValue: 'base-notebook', description: '')
		string(name: 'OriginalImage', defaultValue: 'jupyter/base-notebook', description: '')


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
                    def cfg = readYaml file: 'config.yaml' 
                    def plst = []
                    cfg.${Target}.params.each { p->
                        def name = ${p}
                        println(p)
                        println(name)
                        plst.add(printf("%s:%s",name${name}))
                    }
                    println('plst')
                    plst.each{
                        println "${it}"
                    }

                    def map=[
                        'script':cfg.${Target}.script,
                        'params':plst,
                        ]
                    
                    def out = img.genSh(map)
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