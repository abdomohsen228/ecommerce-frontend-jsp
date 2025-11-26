# E-Commerce Frontend JSP

A Java JSP frontend application serving as the API gateway and user interface for the E-Commerce Order Management System. Built with Jakarta EE and deployed on Apache Tomcat, it handles user interactions, displays product catalogs, manages the order checkout process, and communicates with multiple backend microservices via RESTful APIs.

## Project Overview

This application acts as the frontend layer of a microservices-based e-commerce system. It provides a web interface for customers to browse products, manage their shopping cart, and complete orders. The application integrates with various backend microservices to fetch product information, process orders, and handle user authentication.

### Key Features

- **API Gateway**: Routes requests to appropriate backend microservices
- **Product Catalog**: Displays product listings and details
- **Order Management**: Handles order checkout and processing
- **User Interface**: Provides interactive web pages using JSP
- **Microservices Integration**: Communicates with backend services via RESTful APIs

## Technologies Used

- Java 22
- Jakarta EE (Jakarta Servlet API 6.1.0)
- JSP (Java Server Pages)
- RESTful APIs for microservices communication
- Apache Tomcat (deployment server)
- Maven 3.x

## Prerequisites

- JDK 22 or higher
- Apache Maven 3.6.0 or higher
- Application Server (Apache Tomcat 10.x or higher, or any Jakarta EE 10 compatible server)

## Project Structure

```
ecommerce-frontend-jsp/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── org/msa/ecommercefrontendjsp/
│   │   └── webapp/
│   │       ├── index.jsp
│   │       └── WEB-INF/
│   │           └── web.xml
│   └── test/
├── pom.xml
└── README.md
```

## Getting Started

### Build the Project

**Windows:**
```
.\mvnw.cmd clean package
```

**Unix/Linux/Mac:**
```
./mvnw clean package
```

Or using Maven directly:
```
mvn clean package
```

This will create a WAR file in the `target/` directory.

### Run the Application

**Option 1: Deploy to Tomcat**

1. Copy the WAR file to Tomcat's webapps directory:
   ```
   cp target/ecommerce-frontend-jsp-1.0-SNAPSHOT.war <TOMCAT_HOME>/webapps/
   ```

2. Start Tomcat:
   ```
   <TOMCAT_HOME>/bin/startup.sh    # Unix/Linux/Mac
   <TOMCAT_HOME>/bin/startup.bat   # Windows
   ```

3. Access the application:
   ```
   http://localhost:8080/ecommerce-frontend-jsp-1.0-SNAPSHOT/
   ```

**Option 2: Using IDE**

Import the project into your IDE (IntelliJ IDEA, Eclipse, etc.), configure your application server, and run from the IDE.

## Development

### Adding New Servlets

Create servlet classes in `src/main/java/org/msa/ecommercefrontendjsp/` and annotate with `@WebServlet`:

```java
@WebServlet(name = "productServlet", value = "/products")
public class ProductServlet extends HttpServlet {
    // Implementation
}
```

### Adding New JSP Pages

Create JSP files in `src/main/webapp/` directory.


```
