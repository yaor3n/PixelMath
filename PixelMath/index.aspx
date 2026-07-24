<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="PixelMath.index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Pixel Math - Master Math with Confidence</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="icon" type="image/png" href="images/pixelmath_logo.png" />
    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.9.14/dist/dotlottie-wc.js" type="module"></script>
    
    <!-- 🎯 External Clean CSS Reference -->
    <link rel="stylesheet" href="index-CSS.css" />
</head>
<body>
    <form id="form1" runat="server" style="display:contents">

        <!-- 1. NAVBAR -->
        <header class="index-header">
            <div class="brand-container">
                <img src="images/pixelmath_logo_transparentbg.png" alt="Pixel Math Logo" class="brand-logo" />
                <span class="brand-title">PixelMath</span>
            </div>
            <div class="nav-actions">
                <a href="LoginPage.aspx" class="btn-login">Log In</a>
                <a href="SignUpPage.aspx" class="btn-signup">Sign Up</a>
            </div>
        </header>

        <!-- 2. INTRODUCTION SECTION -->
        <section class="hero-section">
            <div class="hero-container">
                <h1 class="hero-title">
                    The Smarter Way to <span class="text-highlight">Ace Math</span>
                </h1>
                <p class="hero-subtitle">
                    Interactive practice and structured learning modules engineered to elevate your understanding.
                </p>
                <div class="hero-buttons">
                    <a href="SignUpPage.aspx" class="btn-hero-primary">Get Started Free</a>
                    <a href="#advantages" class="btn-hero-secondary">Explore Features</a>
                </div>
            </div>
        </section>

        <!-- 3. ADVANTAGES SECTION -->
        <section id="advantages" class="section-wrapper">
            <div class="section-header">
                <h2 class="section-title">
                    <!-- 🎯 Wrap the target title range in a span container -->
                    <span class="title-span">
                        <!-- 🎯 The animation sits inside the span -->
                        <dotlottie-wc
                            src="https://lottie.host/a63e7b7c-0c2b-4362-81a1-678c67d3f9a9/o4xPx95Xvv.lottie"
                            class="moving-lottie"
                            autoplay
                            loop
                        ></dotlottie-wc>
                        Why Learn with PixelMath?
                    </span>
                </h2>
                <p class="section-subtitle">Designed to make mathematical concepts intuitive and stress-free.</p>
            </div>

            <div class="advantages-grid">
                <div class="advantage-card">
                    <div class="icon-box"><i class="fa-solid fa-layer-group"></i></div>
                    <h3>Structured Curriculum</h3>
                    <p>Curated topic breakdowns tailored to help you build solid foundational knowledge step-by-step.</p>
                </div>

                <div class="advantage-card">
                    <div class="icon-box"><i class="fa-solid fa-bolt"></i></div>
                    <h3>Instant Feedback</h3>
                    <p>Receive instant evaluations on interactive quizzes to identify and correct mistakes immediately.</p>
                </div>

                <div class="advantage-card">
                    <div class="icon-box"><i class="fa-solid fa-chart-line"></i></div>
                    <h3>Progress Analytics</h3>
                    <p>Track your completion metrics and monitor scores over time with intuitive visual reports.</p>
                </div>
            </div>
        </section>

        <!-- 4. STATS JOURNEY SECTION -->
        <section class="stats-banner">
            <div class="stats-grid">
                <div>
                    <!-- 🎯 data-target holds the target number, data-suffix holds the unit (+, %, etc) -->
                    <div class="stat-number" data-target="1000" data-suffix="+">0</div>
                    <div class="stat-label">Active Students</div>
                </div>
                <div>
                    <div class="stat-number" data-target="300" data-suffix="+">0</div>
                    <div class="stat-label">Interactive Quizzes</div>
                </div>
                <div>
                    <div class="stat-number" data-target="95" data-suffix="%">0</div>
                    <div class="stat-label">Improvement Rate</div>
                </div>
                <div>
                    <div class="stat-number" data-target="24" data-suffix="/7">0</div>
                    <div class="stat-label">Resource Access</div>
                </div>
            </div>
        </section>

        <!-- 5. TESTIMONIAL SECTION -->
        <section class="section-wrapper">
            <div class="section-header">
                <h2 class="section-title">Loved by Students & Teachers</h2>
                <p class="section-subtitle">See how PixelMath is transforming student confidence.</p>
            </div>

            <div class="testimonial-grid">
                <div class="testimonial-card">
                    <div class="rating-stars">
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                    </div>
                    <p class="quote-text">"PixelMath completely changed how I revise for math. The quizzes give instant feedback, so I never feel lost!"</p>
                    <div class="author-info">
                        <div class="avatar-circle">
                            <img src="images/Landing-page-student.png" alt="Student Avatar" />
                        </div>
                        <div>
                            <h4 class="author-name">Sky Ong</h4>
                            <p class="author-role">Secondary Student</p>
                        </div>
                    </div>
                </div>

                <div class="testimonial-card">
                    <div class="rating-stars">
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                    </div>
                    <p class="quote-text">"Assigning learning materials and managing student quizzes has never been smoother. Highly recommended!"</p>
                    <div class="author-info">
                        <div class="avatar-circle">
                            <img src="images/Landing-page-teacher.png" alt="Student Avatar" />
                        </div>
                        <div>
                            <h4 class="author-name">Ms. Karina</h4>
                            <p class="author-role">Math Educator</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 6. DUAL CTA CARDS -->
        <section class="section-wrapper">
            <div class="cta-grid">
                
                <!-- Left CTA Card: Take a Quiz -->
                <div class="cta-card cta-left">
                    <div>
                        <div class="cta-icon">
                            <dotlottie-wc
                              src="https://lottie.host/f56b9408-f311-4d7a-8ae1-f11f5fc788c1/2a2uJWEEQ8.lottie"
                              style="width: 300px;height: 300px"
                              autoplay
                              loop
                            ></dotlottie-wc>
                        </div>
                        <h3>Ready to Test Your Skills?</h3>
                        <p>Jump straight into interactive practice quizzes and assess your problem-solving capabilities right away.</p>
                    </div>
                    <a href="Student-Quiz.aspx" class="btn-cta-left">
                        Take a Quiz Now <i class="fa-solid fa-arrow-right" style="margin-left: 6px;"></i>
                    </a>
                </div>

                <!-- Right CTA Card: View Resources -->
                <div class="cta-card cta-right">
                    <div>
                        <div class="cta-icon">
                            <dotlottie-wc
                              src="https://lottie.host/4f1e6646-5642-49db-af74-4996c1b2d8b8/imHK7qWp42.lottie"
                              style="width: 300px;height: 300px"
                              autoplay
                              loop
                            ></dotlottie-wc>
                        </div>
                        <h3>Explore Study Resources</h3>
                        <p>Access downloadable PDF notes, formula sheets, and class materials uploaded directly by your lecturers.</p>
                    </div>
                    <a href="Student-Resources.aspx" class="btn-cta-right">
                        Browse Resources <i class="fa-solid fa-arrow-right" style="margin-left: 6px;"></i>
                    </a>
                </div>

            </div>
        </section>

        <!-- 7. SMALL FOOTER -->
        <footer class="index-footer">
            <div class="footer-container">
                <div class="footer-brand">
                    <img src="images/pixelmath_logo_transparentbg.png" alt="Pixel Math Logo" class="footer-logo" />
                    <span>PixelMath</span>
                </div>
                <p>&copy; 2026 PixelMath. All rights reserved.</p>
            </div>
        </footer>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const counters = document.querySelectorAll('.stat-number');
                const speed = 200; // Animation duration control (higher = slower)

                const startCounting = (counter) => {
                    const target = +counter.getAttribute('data-target');
                    const suffix = counter.getAttribute('data-suffix') || '';
                    let count = 0;
                    const increment = target / speed;

                    const updateCount = () => {
                        count += increment;
                        if (count < target) {
                            // Format number with commas if large (e.g., 10,000)
                            counter.innerText = Math.ceil(count).toLocaleString() + suffix;
                            setTimeout(updateCount, 15);
                        } else {
                            counter.innerText = target.toLocaleString() + suffix;
                        }
                    };

                    updateCount();
                };

                // Trigger animation when stats banner enters viewport
                const observerOptions = {
                    threshold: 0.5 // Triggers when 50% of section is visible
                };

                const observer = new IntersectionObserver((entries, observer) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            const counter = entry.target;
                            startCounting(counter);
                            observer.unobserve(counter); // Run animation once
                        }
                    });
                }, observerOptions);

                counters.forEach(counter => {
                    observer.observe(counter);
                });
            });
        </script>

    </form>
</body>
</html>