pipeline{
    agent {
        label 'aml'
    }
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
    environment {
		BUILDSH = ''
        PUSHSH = ''
        CREDENTIALID =''
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
                    def pmap = [:]
                    
                    cfg[params.Target].params.each { p->
                        def name = params."${p}"
                        // println(p)
                        // println(name)
                        pmap.put(p,name)
                    }
                    println('pmap')
                    pmap.each{
                        println "${it.key}:${it.value}"
                    }

                    def map=[
                        'script':cfg[params.Target].script,
                        'push':cfg[params.Target].push,
                        'params':pmap,
                        ]
                    
                    BUILDSH = img.genBuildSh(map)
                    // println "${env.BUILDSH}"
                    println "${BUILDSH}"
                    PUSHSH = img.genPushSh(map)
                    // println "${env.PUSHSH}"
                    println "${PUSHSH}"

                    CREDENTIALID = cfg[params.Target].pushCredentialId
                    

                }
            }
        }
        stage('gen-images'){
            steps{
                container('tools') { 
                    script{
                        echo "gen images"
                        retry(3) {
                            println "${BUILDSH}"
                            sh "${BUILDSH}"
                        }
                    }
                }
            }
        }
        stage('push-images'){
            steps{
                container('tools') { 
                    script{
                        echo "push images"
                        retry(3) {
                            if (image.credentialId != '') {
                                withCredentials([usernamePassword(credentialsId: ${CREDENTIALID}, passwordVariable: 'PASSWD', usernameVariable: 'USER')]) {
                                    sh "docker login ${params.REGISTRY}/${params.OWNER} -u ${USER} -p ${PASSWD}"
                                }
                            }
                            println "${PUSHSH}"
                            sh "${PUSHSH}"
                        }
                    }
                }
            }
        }
    }
}