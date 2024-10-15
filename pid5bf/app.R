library(surveydown)
library(hitop)

# Database setup
db <- sd_database(
  host   = "aws-0-us-west-1.pooler.supabase.com",
  dbname = "postgres",
  port   = "6543",
  user   = "postgres.outtobdgbkorhxfkpijc",
  table  = "pid5bf",
  ignore = FALSE
)


# Setup server
server <- function(input, output, session) {

  survey_data <- sd_get_data(db, refresh_interval = 10)

  output$my_table <- shiny::renderTable({
    df <- survey_data()
    df2 <- df[df$session_id == session$token, sprintf("bf_%03d", 1:25)]
    hitop::score_pid5bf(df2)
  })

  # Define any conditional skip logic here (skip to page if a condition is true)
  #sd_skip_if()

  # Define any conditional display logic here (show a question if a condition is true)
  #sd_show_if()

  # Database designation and other settings
  sd_server(
    db = db,
    admin_page = TRUE
  )

}

# Initiate shiny
shiny::shinyApp(ui = sd_ui(), server = server)
