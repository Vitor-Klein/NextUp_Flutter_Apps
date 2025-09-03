// functions/index.js (Node 20, ESM)
import { initializeApp } from "firebase-admin/app";
import nodemailer from "nodemailer";

// Firebase Functions v2
import { onCall } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2/options";
import { defineString } from "firebase-functions/params"; // lê de params (.env.<projectId>), não de functions:config

initializeApp();

// Região próxima do Brasil
setGlobalOptions({ region: "southamerica-east1" });

// Parâmetros vindos do CLI (armazenados em .env.<projectId> na pasta functions/)
const SMTP_HOST = defineString("SMTP_HOST");
const SMTP_PORT = defineString("SMTP_PORT");
const SMTP_SECURE = defineString("SMTP_SECURE");
const SMTP_USER = defineString("SMTP_USER");
const SMTP_PASS = defineString("SMTP_PASS");
const SMTP_TO = defineString("SMTP_TO");

function makeTransporter() {
  const host = SMTP_HOST.value();
  const port = Number(SMTP_PORT.value() || 587);
  const secure = String(SMTP_SECURE.value() || "false").toLowerCase() === "true";
  const user = SMTP_USER.value();
  const pass = SMTP_PASS.value();

  if (!host || !user || !pass) {
    throw new Error("SMTP config missing (host/user/pass).");
  }

  return nodemailer.createTransport({
    host,
    port,
    secure, // true: 465, false: 587 (STARTTLS)
    auth: { user, pass },
  });
}

export const sendQuestionForm = onCall(async (request) => {
  const data = request.data || {};

  const name = String(data?.name ?? "").trim();
  const email = String(data?.email ?? "").trim();
  const phone = String(data?.phone ?? "").trim();
  const company = String(data?.company_name ?? "").trim();
  const jobSite = String(data?.job_site_address ?? "").trim();
  const help = String(data?.help_type ?? "").trim();

  if (!name || !email || !phone || !company || !jobSite || !help) {
    return { ok: false, error: "Missing fields." };
  }

  const to = String(data?.to ?? SMTP_TO.value() ?? "").trim();
  if (!to) {
    return { ok: false, error: "Receiver e-mail not configured." };
  }

  const subject = `Question Form: ${help}`;
  const html = `
    <h2>New Question Form Submission</h2>
    <table border="1" cellspacing="0" cellpadding="6">
      <tr><th align="left">Name</th><td>${esc(name)}</td></tr>
      <tr><th align="left">Email</th><td>${esc(email)}</td></tr>
      <tr><th align="left">Phone</th><td>${esc(phone)}</td></tr>
      <tr><th align="left">Company</th><td>${esc(company)}</td></tr>
      <tr><th align="left">Job site address</th><td>${esc(jobSite)}</td></tr>
      <tr><th align="left">Help type</th><td>${esc(help)}</td></tr>
      <tr><th align="left">Timestamp</th><td>${new Date().toISOString()}</td></tr>
    </table>
  `;

  try {
    const transporter = makeTransporter();
    const info = await transporter.sendMail({
      from: `"BFAC" <${SMTP_USER.value()}>`,
      to,
      subject,
      html,
      replyTo: email,
    });
    return { ok: true, id: info.messageId };
  } catch (err) {
    console.error("sendMail error:", err);
    return { ok: false, error: "Mail send failed." };
  }
});

function esc(s) {
  return String(s)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}
