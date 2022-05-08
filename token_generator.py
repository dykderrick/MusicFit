import datetime
import jwt


secret = """-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg7dmYF15YW9tj6SU4
FD9OThGH1wNq7H4apFk8u0swhr2gCgYIKoZIzj0DAQehRANCAAQF+a9PMnrlIEyP
09/Rx9qundJ0oq4PDrgnirfjMdOzSeDLDekphPyvUM6xHsowBDUDHhJWvH5gIbuV
5yg0EENJ
-----END PRIVATE KEY-----"""
keyId = "5QLD7TV4H4"
teamId = "G82CLNVA64"
alg = 'ES256'

time_now = datetime.datetime.now()
time_expired = datetime.datetime.now() + datetime.timedelta(hours=4380)

headers = {
	"alg": alg,
	"kid": keyId
}

payload = {
	"iss": teamId,
	"exp": int(time_expired.strftime("%s")),
	"iat": int(time_now.strftime("%s"))
}


if __name__ == "__main__":
	"""Create an auth token"""
	token = jwt.encode(payload, secret, algorithm=alg, headers=headers)

	print("----TOKEN----")
	print(token)

	print("----CURL----")
	print("curl -v -H 'Authorization: Bearer %s' \"https://api.music.apple.com/v1/catalog/us/artists/36954\" " % (token))

