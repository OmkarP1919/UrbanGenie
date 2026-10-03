package util;

import java.security.MessageDigest;

/**
 * PasswordUtil - SHA-256 password hashing utility.
 * Uses Java built-in MessageDigest (no external library needed).
 */
public class PasswordUtil {

    /**
     * Hashes a plain-text password using SHA-256.
     * Returns a 64-character lowercase hex string.
     */
    public static String hash(String plainText) {
        if (plainText == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(plainText.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Hashing failed", e);
        }
    }

    /**
     * Verifies a plain-text password against a stored hash.
     */
    public static boolean verify(String plainText, String storedHash) {
        if (plainText == null || storedHash == null) {
            return false;
        }
        return hash(plainText).equals(storedHash);
    }
}
