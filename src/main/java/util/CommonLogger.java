package util;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;
import java.util.concurrent.locks.ReentrantLock;

public class CommonLogger {
    private static final String LOG_FILE_NAME = "log.log";
    private static final String LOG_DIR_PATH;
    private static final ReentrantLock lock = new ReentrantLock();
    static {
        LOG_DIR_PATH = "D:/Java/Dormitory_Management_Servlet" + File.separator;
        
        File logsDir = new File(LOG_DIR_PATH);
        if (!logsDir.exists()) {
            boolean created = logsDir.mkdirs();
            if (!created) {
                System.err.println("Không thể tạo thư mục log tại " + LOG_DIR_PATH);
            }
        }
    }
    public static synchronized void logEvent(String event) {
    	lock.lock();
        try (FileWriter fw = new FileWriter(LOG_DIR_PATH + LOG_FILE_NAME, true)) {
            fw.write(String.format("%1$tT %1$tF : %2$s%n", new Date(), event));
        } catch (IOException e) {
            System.err.println("Không thể ghi file log tại " + LOG_DIR_PATH + LOG_FILE_NAME + ": " + e.getMessage());
        } finally {
            lock.unlock();
        }
    }
}