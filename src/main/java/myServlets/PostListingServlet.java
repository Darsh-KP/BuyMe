package myServlets;

import com.buyme.controller.*;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;


@WebServlet("/PostListingServlet")
@MultipartConfig
public class PostListingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public PostListingServlet() {}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the form was submitted
        if (request.getMethod().equalsIgnoreCase("POST")) {
            // Get listing information from form
            String productName = request.getParameter("productName").trim();
            String productDescription = request.getParameter("productDescription").trim();
            InputStream imageBinary = request.getPart("productImage").getInputStream();
            String subcategory = request.getParameter("subcategory").trim();
            double initialPrice = Double.parseDouble(request.getParameter("initialPrice"));
            double minSellPrice = Double.parseDouble(request.getParameter("minSellPrice"));
            double minBidIncrement = Double.parseDouble(request.getParameter("minBidIncrement"));
            String listingStartDateTimeString = request.getParameter("listingStartDateTime");
            String listingCloseDateTimeString = request.getParameter("listingCloseDateTime");

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime listingStartDateTime = LocalDateTime.parse(listingStartDateTimeString, formatter);
            LocalDateTime listingCloseDateTime = LocalDateTime.parse(listingCloseDateTimeString, formatter);

            // Get derived information
            LocalDateTime listingPostDateTime = LocalDateTime.now();
            HttpSession session = request.getSession();
            String sellerUsername = session.getAttribute("user").toString();

            // Create a html form to send the return status
            StringBuilder htmlForm = new StringBuilder();
            htmlForm.append("<html><body>");
            htmlForm.append("<form id=\"postStatusForm\" method=\"post\" action=\"PostListing.jsp\">");

            // Attempt new post
            if (!postListingController.attemptPost(productName, productDescription, subcategory, initialPrice,
                    minSellPrice, minBidIncrement, listingCloseDateTime, listingPostDateTime, sellerUsername, imageBinary, listingStartDateTime)) {
                // Failed to post listing
                htmlForm.append("<input type=\"hidden\" name=\"postStatus\" value=\"" + "failed" + "\">");
            } else {
                // Success
                htmlForm.append("<input type=\"hidden\" name=\"postStatus\" value=\"" + "success" + "\">");
            }

            // Finish html response
            htmlForm.append("</form>");
            htmlForm.append("<script type=\"text/javascript\">");
            htmlForm.append("document.getElementById('postStatusForm').submit();");
            htmlForm.append("</script>");
            htmlForm.append("</body></html>");

            // Send HTML response
            response.setContentType("text/html");
            response.getWriter().write(htmlForm.toString());
        }
	}
}
