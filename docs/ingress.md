# Multi layered application

## Executive summary

In our multi layered architecture, the frontend and backend of our applications
are intricately linked, with the backend coded in Python and the frontend in
TypeScript, each residing in their respective directories. The backend not only
processes requests but also occasionally interacts with various object storage
solutions, such as AI models, databases, and blob storage, to manage and
retrieve data. This interaction is crucial for the seamless operation of our
services and is depicted in the accompanying of sequence diagrams, which
illustrates the flow of a request from the frontend through the ingress to the
backend.

## Glossary

**Frontend:** Frontend refers to the part of a website or application that users
interact with directly, encompassing the design, layout, and behavior that
people experience within a web browser or app interface.

**Backend:** The backend refers to the server-side of a web application,
encompassing the database, server, and application logic that process user
requests and perform the core functional operations of the system.

**Database:** A database is a structured collection of data that is stored and
accessed electronically, designed to manage, query, and retrieve information
efficiently.

**Ingress:** Ingress refers to the act of entering or the ability to enter.
n the context of networking and computing, it typically denotes incoming traffic
to a network or service from an external source.

**Browser:** A browser, also known as a web browser, is a software application
used to access, retrieve, and view content on the World Wide Web, including
webpages,  images, videos, and other multimedia. It interprets HTML and other
web technologies to present information in an accessible format.

## Diagram

This diagram shows the communication between the `frontend`, the
`backend (/api)`, the `browser (client)`, and the `ingress (ingress nginx)`
for an application.
```mermaid
sequenceDiagram
    participant Browser
    participant Ingress
    participant Frontend
    participant Backend

    Note over Browser,Backend: DNS https://inspection.alpha.canada.ca resolves to Ingress IP with A record
    Note over Browser,Backend: https://*.inspection.alpha.canada.ca * is any CNAME to the DNS

    Browser->>Ingress: GET / https://*.inspection.alpha.canada.ca
    Ingress->>Frontend: GET /
    Frontend-->>Ingress: 200
    Ingress-->>Browser: The browser display the result

    Browser->>Ingress: GET /api/search https://*.inspection.alpha.canada.ca/api/search/
    Ingress->>Backend: GET /search
    Note over Ingress: /api is /search (ImplementationSpecific)
    Backend-->>Ingress: 200
    Ingress-->>Browser: The browser display the result
```

## References

[Ingress NGINX](https://docs.nginx.com/nginx-ingress-controller/)

[Ingress NGINX - ImplementationSpecific](
https://docs.nginx.com/nginx-ingress-controller/configuration/ingress-resources/basic-configuration/)

[DNS](https://www.fortinet.com/resources/cyberglossary/what-is-dns)

[DNS - A record](
https://support.google.com/a/answer/2576578?hl=en#zippy=%2Chow-a-records-work%2Cconfigure-a-records-now)

[DNS - CNAME record](
https://support.google.com/a/answer/112037?hl=en#zippy=%2Cset-up-cname-records-now)
