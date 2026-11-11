// Retry a flaky step (network calls, registry pushes) with exponential backoff.
//
//   withRetry(attempts: 4, initialDelaySeconds: 5) { sh 'docker push my/image:tag' }
def call(Map cfg = [:], Closure body) {
    int attempts = (cfg.attempts ?: 3) as int
    int delay = (cfg.initialDelaySeconds ?: 5) as int
    for (int i = 1; i <= attempts; i++) {
        try {
            return body()
        } catch (err) {
            if (i == attempts) {
                throw err
            }
            echo "Attempt ${i}/${attempts} failed (${err.message}); retrying in ${delay}s"
            sleep time: delay, unit: 'SECONDS'
            delay *= 2
        }
    }
}
