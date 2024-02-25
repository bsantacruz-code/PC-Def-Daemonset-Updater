import requests, json, os

# Prisma Cloud CWPP API parameters:
prisma_cwpp_api_url = 'https://us-east1.cloud.twistlock.com/us-2-158286553'
# prisma_cwpp_api_url = os.environ['PRISMA_CWPP_API_URL']
prisma_api_version = 'v1'
token = ""

print(prisma_cwpp_api_url)

# Prisma Cloud CWPP API endpoints:
authenticate = '/api/{prisma_api_version}/authenticate'
defender_version = '/api/{prisma_api_version}/defenders/image-name'

# Authenticate with CWPP API to get auth token:
def cwpp_login():
    global token
    # Access credentials from environment variables
    prisma_access_key = os.getenv('PRISMA_AK')
    prisma_secret_key = os.getenv('PRISMA_SK')
    prisma_login_url = f"{prisma_cwpp_api_url}/{authenticate}"
    
    payload = {
        'username': 'prisma_access_key',
        'password': 'prisma_secret_key'
    }

    headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
    }

    response = requests.request("POST", prisma_login_url, data=payload, headers=headers)
    if response.status_code == 200:
        token = (json.loads(response.text))["token"]
        # return (json.loads(response.text))["token"]
    else: 
        raise ValueError(response.text)

'''def get_defender_image_name(auth_token):
    """Fetch the latest Prisma Cloud Defender image name using the auth token."""
    headers = {'Authorization': f'Bearer {auth_token}'}
    response = requests.get(PRISMA_API_URL, headers=headers)
    response.raise_for_status()
    return response.json()  # Return the entire JSON response'''

def main():
    # Authenticate and get the auth token
    cwpp_login()
    print("Successfully authenticated with Prisma Cloud API.")
    '''
    # Use the auth token to fetch the Defender image name (entire response)
    response_data = get_defender_image_name(auth_token)
    print("Response from Prisma Cloud API:", response_data)
except requests.HTTPError as http_err:
    print(f"HTTP error occurred: {http_err}")
except Exception as err:
    print(f"An error occurred: {err}")
'''

main()