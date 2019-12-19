# Sample REST API usage with cUrl

## Get a customer

```bash
curl -s -k -X GET https://localhost:5001/customer/121
```

## Create new customer

```bash
curl -s -k -H "Content-Type: application/json" -X PUT https://localhost:5001/customer -d '{"CustomerName": "John Doe", "PhoneNumber": "123-234-5678", "FaxNumber": "123-234-5678", "WebsiteURL": "http://www.something.com", "Delivery": { "AddressLine1": "One Microsoft Way", "PostalCode": 98052 }}'
```

## Update customer

```bash
curl -s -k -H "Content-Type: application/json" -X PATCH http://localhost:5000/customer/123 -d '{"CustomerName": "Jane Dean", "PhoneNumber": "231-778-5678" }'
```

## Delete a customer

```bash
curl -s -k -X DELETE http://localhost:5000/customer/123
```
