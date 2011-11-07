function encryptPassword(){
    pem = document.getElementById('public_key').value;

    if(pem.substr(0,31)!="-----BEGIN RSA PUBLIC KEY-----\n") return false;
    pem = pem.substr(31);
    if(pem.substr(64,1)!="\n") return false;
    pem = pem.substr(0, 64) + pem.substr(65);
    if(pem.substr(128,1)!="\n") return false;
    pem = pem.substr(0, 128) + pem.substr(129);
    if(pem.substr(pem.length-30)!="\n-----END RSA PUBLIC KEY-----\n") return false;
    pem = pem.substr(0,pem.length-30);

    key = new RSAKey()
    key.setPublic(b64tohex(pem), '10001')

    plainTextPassword = document.getElementById('password').value;
    encryptedPassword = key.encrypt(plainTextPassword);

    document.getElementById('password').value = encryptedPassword;
}